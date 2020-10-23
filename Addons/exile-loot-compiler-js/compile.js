var fs = require('fs');
var glob = require("glob");
var async = require("async");
var strip = require('strip-comments');
var ejs = require('ejs');

var groups = [];

var dpcount = 6;
function round(n, dp) {
    var b = Math.pow(10, dp);
    return Math.round(n * b) / b;
}

function GroupItem(name, chance) {
    this.name = name;
    this.chance = chance;
}

function Group(name) {
    this.name = name;
    this.items = [];
}

Group.prototype.AddItem = function(item) {
    this.items.push(item);
};

Group.prototype.GetChances = function() {
    var group = this;
    var chance_count = 0;
    this.total = this.items.reduce(function(a, b) {
        return (a + b.chance);
    }, 0);
    this.items.forEach(function(item, i) {
        item.chance_count = item.chance / group.total;
    });
};

function parseFile(file, next) {
    async.waterfall([
        function(next) {
            fs.readFile(file, 'utf8', next);
        },
        function(content, next) {
            content = strip(content).split('\r\n');
            var group = null;
            content.forEach(function(line, i) {
                if (line == "") return;
                if (line.charAt(0) == '>') {
                    if (group) {
                        group.GetChances();
                        groups.push(group);
                    }
                    var groupname = line.replace(/\>\s*/, '');
                    group = new Group(groupname);
                } else {
                    var matches = line.match(/([0-9]+),\s*([\S]+)/);
                    if (!matches || !group) return;
                    var chance = matches[1];
                    var classname = matches[2].replace(/\s/g, '');
                    group.AddItem(new GroupItem(classname, parseInt(chance)));
                }
            });
            if (group && groups[groups.length - 1].name != group.name) {
                group.GetChances();
                groups.push(group);
            }
            next();
        }
    ], next);
}

function compileItems(group) {
    var i = [];
    group.items.forEach(function(item) {
        var subgroup = groups.filter(function(g) {
            return g.name == item.name;
        });
        if (subgroup.length > 0) {
            var subitems = compileItems(subgroup[0]);
            subitems.forEach(function(j) {
                i.push({
                    name: j.name,
                    chance: j.chance * item.chance_count
                });
            });
        } else {
            i.push({
                name: item.name,
                chance: item.chance_count
            });
        }
    });
    return i;
}

function compileLoot(next) {
    var tables = [];
    groups.forEach(function(group, i) {
        var items = compileItems(group);
        var table = {
        	name: group.name,
        	count: items.length,
        	half: 0,
        	halfIndex: Math.floor(items.length / 2) - 1,
        	sum: items.reduce(function (a, b) {return a + b.chance;}, 0),
        	items: []
        };
        var chance = 0;
        items.sort(function (a, b) {
            return b.chance - a.chance;
        });
    	items.forEach(function (item, i) {
    		var percent = item.chance / table.sum;
    		chance += percent;
    		table.items.push({
    			name: item.name,
    			chance: round(chance, dpcount),
    			percent: round(percent * 100, 4)
    		});
    		if (i == table.halfIndex) {
    			table.half = round(chance, dpcount);
    		}
    	});
    	table.sum = round(table.sum, dpcount);
        tables.push(table);
    });
    next(null, tables);
}

async.waterfall([
    function (next) {
        glob("**/*.h", next);
    },
    function (files, next) {
        async.each(files, parseFile, function(err) {
            next(err);
        });
    },
    function (next) {
        compileLoot(next);
    },
    function (tables, next) {
    	fs.readFile('CfgLootTables.tpl', 'utf-8', function (err, template) {
    		next(err, template, tables);
    	});
    },
    function (template, tables, next) {
    	var groups = tables.map(function (table) {return table.name;});
    	var cfg = ejs.render(template, {tables: tables, groups: groups});
    	fs.writeFile('CfgLootTables.hpp', cfg, next);
    }
], function(err) {
    console.log(err || "All good, no errors");
});