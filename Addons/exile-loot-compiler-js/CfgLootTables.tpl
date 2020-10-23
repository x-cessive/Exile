/*
Loot Groups
<% groups.forEach(function(group) { %><%= group %>
<% }) %>*/
class CfgLootTables {<% tables.forEach(function(group) { %>
	class <%= group.name %> {
		count = <%= group.count %>;
		half = <%= group.half * 10000 %>;
		halfIndex = <%= group.halfIndex %>;
		sum = <%= group.sum * 10000 %>;
		items[] = 
		{<% group.items.forEach(function(item, i) { %>
			{<%= item.chance * 10000 %>, "<%= item.name %>"}<% if (i != group.items.length - 1) { %>,<% } %>// <%= item.percent %>%<% }) %> 
		};
	};<% }) %>
};