//////////////////////////////////////////////////////////////
// Escape shuttle and pods
/datum/shuttle/autodock/ferry/emergency/escape
	name = "Escape"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/escape
	warmup_time = 10
	landmark_offsite = "escape_cc"
	landmark_station = "escape_triumph"
	landmark_transition = "escape_transit"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

//////////////////////////////////////////////////////////////
//Old Escape Pod
/*
/datum/shuttle/autodock/ferry/escape_pod/large_escape_pod1
	name = "Large Escape Pod 1"
	location = FERRY_LOCATION_STATION
	shuttle_area = /area/shuttle/large_escape_pod1
	warmup_time = 0
	landmark_station = "escapepod1_station"
	landmark_offsite = "escapepod1_cc"
	landmark_transition = "escapepod1_transit"
	docking_controller_tag = "large_escape_pod_1"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN
*/
//////////////////////////////////////////////////////////////
// Supply shuttle
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/supply
	warmup_time = 10
	landmark_offsite = "supply_cc"
	landmark_station = "supply_dock"
	docking_controller_tag = "supply_shuttle"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY
/*
//////////////////////////////////////////////////////////////
// TODO - Zandario/Enzo - Get these compatible
// Trade Ship
/datum/shuttle/autodock/multi/trade
	name = "Trade"
	current_location = "trade_dock"
	shuttle_area = /area/shuttle/trade
	docking_controller_tag = "trade_shuttle"
	warmup_time = 10	// Want some warmup time so people can cancel.
	destination_tags = list(
		"cc_trade_dock",
		"nav_capitalship_docking1",
		"nav_capitalship_docking2",
		"trade_dock",
		"tether_dockarm_d1l",
		"aerostat_south",
		"beach_e",
		"beach_c",
		"beach_nw"
	)
	defer_initialisation = TRUE
	move_direction = WEST

//////////////////////////////////////////////////////////////
// Mercenary Shuttle
/datum/shuttle/autodock/multi/mercenary
	name = "Mercenary"
	warmup_time = 8
	move_time = 60
	current_location = "merc_base"
	shuttle_area = /area/shuttle/mercenary
	destination_tags = list(
		"merc_base",
		"aerostat_south",
		"beach_e",
		"beach_nw",
		"triumph_space_port_3",
		"triumph_space_starboard_3",
		"triumph_space_port_2",
		"triumph_space_starboard_2",
		"triumph_space_port_1",
		"triumph_space_starboard_1"
		)
	docking_controller_tag = "merc_shuttle"
	announcer = "Automated Traffic Control"
	arrival_message = "Attention. An unregistered vessel is approaching NSV Triumph."
	departure_message = "Attention. A unregistered vessel is now leaving NSV Triumph."
	defer_initialisation = TRUE
	move_direction = WEST

//////////////////////////////////////////////////////////////
// Ninja Shuttle
/datum/shuttle/autodock/multi/ninja
	name = "Ninja"
	warmup_time = 8
	move_time = 60
	can_cloak = TRUE
	cloaked = TRUE
	current_location = "ninja_base"
	landmark_transition = "ninja_transit"
	shuttle_area = /area/shuttle/ninja
	destination_tags = list(
		"ninja_base",
		"aerostat_northeast",
		"beach_e",
		"beach_nw",
		"triumph_space_port_3",
		"triumph_space_starboard_3",
		"triumph_space_port_2",
		"triumph_space_starboard_2",
		"triumph_space_port_1",
		"triumph_space_starboard_1"
		)
	docking_controller_tag = "ninja_shuttle"
	announcer = "Automated Traffic Control"
	arrival_message = "Attention. An unregistered vessel is approaching NSV Triumph."
	departure_message = "Attention. A unregistered vessel is now leaving NSV Triumph."

//////////////////////////////////////////////////////////////
// Skipjack
/datum/shuttle/autodock/multi/heist
	name = "Skipjack"
	warmup_time = 8
	move_time = 60
	can_cloak = TRUE
	cloaked = TRUE
	current_location = "skipjack_base"
	landmark_transition = "skipjack_transit"
	shuttle_area = /area/shuttle/skipjack
	destination_tags = list(
		"piratebase_hanger",
		"skipjack_base",
		"aerostat_south",
		"beach_e",
		"beach_nw",
		"triumph_space_port_3",
		"triumph_space_starboard_3",
		"triumph_space_port_2",
		"triumph_space_starboard_2",
		"triumph_space_port_1",
		"triumph_space_starboard_1"
		)
	/* // Whatever this is doesnt work, will have to fix later
	//docking_controller_tag = ??? doesn't have one?
	destination_dock_targets = list(
		"Mercenary base" = "merc_base",
		"Tether spaceport" = "nuke_shuttle_dock_airlock",
		)
	*/
	announcer = "Automated Traffic Control"

	arrival_message = "Attention. An unregistered vessel is approaching NSV Triumph."
	departure_message = "Attention. A unregistered vessel is now leaving NSV Triumph."

//////////////////////////////////////////////////////////////
// ERT Shuttle

/datum/shuttle/autodock/multi/specialops
	name = "NDV Phantom"
	can_cloak = TRUE
	cloaked = FALSE
	warmup_time = 8
	move_time = 60
	current_location = "specops_base"
	landmark_transition = "specops_transit"
	shuttle_area = /area/shuttle/specialops
	destination_tags = list(
		"specops_base",
		"aerostat_northwest",
		"triumph_space_port_3",
		"triumph_space_starboard_3",
		"triumph_space_port_2",
		"triumph_space_starboard_2",
		"triumph_space_port_1",
		"triumph_space_starboard_1"
		)
	docking_controller_tag = "specops_shuttle_hatch"
	announcer = "Automated Traffic Control"
	arrival_message = "Attention. An NT support vessel is approaching NSV Triumph."
	departure_message = "Attention. A NT support vessel is now leaving NSV Triumph."
*/
//////////////////////////////////////////////////////////////
// RogueMiner "Belter: Shuttle
// TODO - Not implemented yet on new map

/datum/shuttle/autodock/ferry/belter
	name = "Belter"
	location = FERRY_LOCATION_STATION
	warmup_time = 6
	move_time = 20 // i am fairly sure this is in seconds
	shuttle_area = /area/shuttle/belter
	landmark_station = "belter_station"
	landmark_offsite = "belter_zone1"
	landmark_transition = "belter_transit"
	docking_controller_tag = "belter_docking"

/datum/shuttle/autodock/ferry/belter/New()
	move_time = move_time + rand(-5, 10) //30s max, 15s min, probably leaning towards higher values.
	..()


//////////////////////////////////////////////////////////////
// CC Lewdship shuttle
// DISABLED - cruiser has been removed entirely
/*
/datum/shuttle/autodock/ferry/cruiser_shuttle
	name = "Cruiser Shuttle"
	location = 1
	warmup_time = 10	//want some warmup time so people can cancel.
	area_offsite = /area/shuttle/cruiser/cruiser
	area_station = /area/shuttle/cruiser/station
	docking_controller_tag = "cruiser_shuttle"
	dock_target_station = "d1a1_dock"
	dock_target_offsite = "cruiser_shuttle_bay"
*/
