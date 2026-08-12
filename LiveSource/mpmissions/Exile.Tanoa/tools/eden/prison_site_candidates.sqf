/*
    PRISON-GRAYBOX-001 - temporary Eden site candidate markers.

    Run manually from the Eden debug console after opening Exile.Tanoa.
    This creates one undoable history step and a non-authoritative layer named
    PRISON_SITE_CANDIDATES. It does not build prison geometry.
*/

if (!is3DEN) exitWith {
    systemChat "PRISON-GRAYBOX-001: open the mission in Eden before running this helper.";
};

private _candidates = [
    [
        "A_NORTH_CENTRAL_COAST",
        "North-central coastal plain",
        [7140, 11800, 0],
        [520, 360],
        35,
        "Room for a coastal/dock prison concept; near road network; verify slope and distance from Nicolet/trader activity."
    ],
    [
        "B_EAST_INLAND_APPROACH",
        "East-island inland approach",
        [13300, 10400, 0],
        [560, 380],
        315,
        "Isolated institution feel with long approaches; good drone/counter-drone sight-line candidate; coastal route requires review."
    ],
    [
        "C_WESTERN_COASTAL_EDGE",
        "Western coastal edge",
        [4400, 11850, 0],
        [500, 340],
        80,
        "Potential prisoner-transfer dock flavor; must verify contaminated-zone separation, flatness and road approach quality."
    ]
];

["PRISON-GRAYBOX-001 site candidates", "PRISON_SITE_CANDIDATES", "a3\3den\data\cfg3den\history\create_ca.paa"] collect3DENHistory {
    private _layerId = -1 add3DENLayer "PRISON_SITE_CANDIDATES";

    {
        _x params ["_id", "_label", "_pos", "_size", "_heading", "_notes"];

        private _comment = create3DENEntity ["Comment", "", _pos];
        _comment set3DENAttribute ["name", format ["PRISON_SITE_%1", _id]];
        _comment set3DENAttribute ["description", format [
            "%1\nAnchor: %2\nApprox footprint: %3m x %4m\nOrientation: %5 deg\n%6",
            _label,
            _pos,
            _size select 0,
            _size select 1,
            _heading,
            _notes
        ]];
        _comment set3DENLayer _layerId;

        private _icon = create3DENEntity ["Marker", "mil_warning", _pos];
        _icon set3DENAttribute ["markerName", format ["PRISON_SITE_%1_ANCHOR", _id]];
        _icon set3DENAttribute ["text", format ["PRISON %1", _id]];
        _icon set3DENLayer _layerId;

        private _area = create3DENEntity ["Marker", "", _pos];
        _area set3DENAttribute ["markerName", format ["PRISON_SITE_%1_FOOTPRINT", _id]];
        _area set3DENAttribute ["text", _label];
        _area set3DENAttribute ["markerType", 0];
        _area set3DENAttribute ["brush", "Border"];
        _area set3DENAttribute ["size2", [(_size select 0) / 2, (_size select 1) / 2]];
        _area set3DENAttribute ["rotation", _heading];
        _area set3DENLayer _layerId;
    } forEach _candidates;
};

systemChat "PRISON-GRAYBOX-001: temporary site candidates added. Undo once to remove them.";
