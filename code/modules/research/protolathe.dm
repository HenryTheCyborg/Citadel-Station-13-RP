/obj/machinery/r_n_d/protolathe
	name = "Protolathe"
	icon = 'icons/obj/machines/fabricators/protolathe.dmi'
	icon_state = "protolathe"
	base_icon_state = "protolathe"
	flags = OPENCONTAINER
	circuit = /obj/item/circuitboard/protolathe
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 5000

	var/max_material_storage = 100000

	var/list/datum/design/queue = list()
	var/progress = 0

	var/mat_efficiency = 1
	var/speed = 1

	materials = list(MAT_STEEL = 0, MAT_GLASS = 0, MAT_PLASTEEL = 0, MAT_PLASTIC = 0, MAT_GOLD = 0, MAT_SILVER = 0, MAT_COPPER = 0, MAT_OSMIUM = 0, MAT_LEAD = 0, MAT_PHORON = 0, MAT_URANIUM = 0, MAT_DIAMOND = 0, MAT_DURASTEEL = 0, MAT_VERDANTIUM = 0, MAT_MORPHIUM = 0, MAT_METALHYDROGEN = 0, MAT_SUPERMATTER = 0)

	hidden_materials = list(MAT_PLASTEEL, MAT_DURASTEEL, MAT_VERDANTIUM, MAT_MORPHIUM, MAT_METALHYDROGEN, MAT_SUPERMATTER)

/obj/machinery/r_n_d/protolathe/Initialize(mapload)
	. = ..()
	default_apply_parts()

/obj/machinery/r_n_d/protolathe/process(delta_time)
	..()
	if(machine_stat)
		update_appearance()
		return
	if(queue.len == 0)
		busy = 0
		update_appearance()
		return
	var/datum/design/D = queue[1]
	if(canBuild(D))
		busy = 1
		progress += speed
		if(progress >= D.time)
			build(D)
			progress = 0
			removeFromQueue(1)
		update_appearance()
	else
		if(busy)
			visible_message(SPAN_NOTICE("\icon [src] flashes: insufficient materials: [getLackingMaterials(D)]."))
			busy = 0
			update_appearance()

/obj/machinery/r_n_d/protolathe/proc/TotalMaterials() //returns the total of all the stored materials. Makes code neater.
	var/t = 0
	for(var/f in materials)
		t += materials[f]
	return t

/obj/machinery/r_n_d/protolathe/RefreshParts()
	var/T = 0
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		T += G.reagents.maximum_volume
	create_reagents(T)
	max_material_storage = 0
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		max_material_storage += M.rating * 75000
	T = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		T += M.rating
	mat_efficiency = max(1 - (T - 2) / 8, 0.2)
	speed = T / 2

/obj/machinery/r_n_d/protolathe/dismantle()
	for(var/f in materials)
		eject_materials(f, -1)
	..()

/obj/machinery/r_n_d/protolathe/update_overlays()
	. = ..()
	cut_overlays()
	if(panel_open)
		add_overlay("[base_icon_state]-panel")

/obj/machinery/r_n_d/protolathe/update_icon_state()
	. = ..()
	if(machine_stat & NOPOWER)
		icon_state = "[base_icon_state]-off"
	else if(busy)
		icon_state = "[base_icon_state]-active"
	else
		icon_state = base_icon_state

/obj/machinery/r_n_d/protolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(busy)
		to_chat(user, SPAN_NOTICE("\The [src] is busy. Please wait for completion of previous operation."))
		return 1
	if(default_deconstruction_screwdriver(user, O))
		if(linked_console)
			linked_console.linked_lathe = null
			linked_console = null
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(O.is_open_container())
		return 1
	if(istype(O, /obj/item/gripper/no_use/loader))
		return 0		//Sheet loaders weren't finishing attack(), this prevents the message "You can't stuff that gripper into this" without preventing the rest of the attack sequence from finishing
	if(panel_open)
		to_chat(user, "<span class='notice'>You can't load \the [src] while it's opened.</span>")
		return 1
	if(!linked_console)
		to_chat(user, "<span class='notice'>\The [src] must be linked to an R&D console first!</span>")
		return 1
	if(!istype(O, /obj/item/stack/material))
		to_chat(user, "<span class='notice'>You cannot insert this item into \the [src]!</span>")
		return 1
	if(machine_stat)
		return 1

	var/obj/item/stack/material/S = O
	if(!(S.material.name in materials))
		to_chat(user, "<span class='warning'>The [src] doesn't accept [S.material]!</span>")
		return

	busy = 1
	var/sname = "[S.name]"
	var/amnt = S.perunit
	var/max_res_amount = max_material_storage
	for(var/mat in materials)
		max_res_amount -= materials[mat]

	if(materials[S.material.name] + amnt <= max_res_amount)
		if(S && S.get_amount() >= 1)
			var/count = 0
			overlays += "fab-load-metal"
			spawn(10)
				overlays -= "fab-load-metal"
			while(materials[S.material.name] + amnt <= max_res_amount && S.get_amount() >= 1)
				materials[S.material.name] += amnt
				S.use(1)
				count++
			to_chat(user, "You insert [count] [sname] into the fabricator.")
	else
		to_chat(user, "The fabricator cannot hold more [sname].")
	busy = 0

	var/stacktype = S.type
	var/t = getMaterialName(stacktype)
	overlays += "protolathe_[t]"
	spawn(10)
		overlays -= "protolathe_[t]"

	updateUsrDialog()
	return

/obj/machinery/r_n_d/protolathe/proc/addToQueue(var/datum/design/D)
	queue += D
	return

/obj/machinery/r_n_d/protolathe/proc/removeFromQueue(var/index)
	queue.Cut(index, index + 1)
	return

/obj/machinery/r_n_d/protolathe/proc/canBuild(var/datum/design/D)
	for(var/M in D.materials)
		if(materials[M] < (D.materials[M] * mat_efficiency))
			return 0
	for(var/C in D.chemicals)
		if(!reagents.has_reagent(C, D.chemicals[C] * mat_efficiency))
			return 0
	return 1

/obj/machinery/r_n_d/protolathe/proc/getLackingMaterials(var/datum/design/D)
	var/ret = ""
	for(var/M in D.materials)
		if(materials[M] < D.materials[M])
			if(ret != "")
				ret += ", "
			ret += "[D.materials[M] - materials[M]] [M]"
	for(var/C in D.chemicals)
		if(!reagents.has_reagent(C, D.chemicals[C]))
			if(ret != "")
				ret += ", "
			ret += C
	return ret

/obj/machinery/r_n_d/protolathe/proc/build(var/datum/design/D)
	var/power = active_power_usage
	for(var/M in D.materials)
		power += round(D.materials[M] / 5)
	power = max(active_power_usage, power)
	use_power(power)
	for(var/M in D.materials)
		materials[M] = max(0, materials[M] - D.materials[M] * mat_efficiency)
	for(var/C in D.chemicals)
		reagents.remove_reagent(C, D.chemicals[C] * mat_efficiency)

	if(D.build_path)
		var/obj/new_item = D.Fabricate(drop_location(), src)
		if(mat_efficiency != 1) // No matter out of nowhere
			if(new_item.matter && new_item.matter.len > 0)
				for(var/i in new_item.matter)
					new_item.matter[i] = new_item.matter[i] * mat_efficiency

/obj/machinery/r_n_d/protolathe/proc/eject_materials(var/material, var/amount) // 0 amount = 0 means ejecting a full stack; -1 means eject everything
	var/recursive = amount == -1 ? 1 : 0
	material = lowertext(material)
	var/obj/item/stack/material/mattype
	var/datum/material/MAT = get_material_by_name(material)

	if(!MAT)
		return

	mattype = MAT.stack_type

	if(!mattype)
		return

	var/obj/item/stack/material/S = new mattype(loc)
	if(amount <= 0)
		amount = S.max_amount
	var/ejected = min(round(materials[material] / S.perunit), amount)
	S.amount = min(ejected, amount)
	if(S.amount <= 0)
		qdel(S)
		return
	materials[material] -= ejected * S.perunit
	if(recursive && materials[material] >= S.perunit)
		eject_materials(material, -1)
