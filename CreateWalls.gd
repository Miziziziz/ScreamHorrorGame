extends Spatial


var wall_block = preload("res://environment/Block.tscn")
onready var gridmap = $GridMap

func _ready():
	for cell_coord in gridmap.get_used_cells():
		var new_pos = gridmap.map_to_world(cell_coord.x, cell_coord.y, cell_coord.z)
		var wall_block_inst = wall_block.instance()
		add_child(wall_block_inst)
		wall_block_inst.global_transform.origin = new_pos
		if gridmap.get_cell_item(cell_coord.x + 1, cell_coord.y, cell_coord.z) >= 0:
			wall_block_inst.get_node("WallXP").disabled = true
			wall_block_inst.get_node("WallXP").hide()
		if gridmap.get_cell_item(cell_coord.x - 1, cell_coord.y, cell_coord.z) >= 0:
			wall_block_inst.get_node("WallXN").disabled = true
			wall_block_inst.get_node("WallXN").hide()
		if gridmap.get_cell_item(cell_coord.x, cell_coord.y, cell_coord.z + 1) >= 0:
			wall_block_inst.get_node("WallZP").disabled = true
			wall_block_inst.get_node("WallZP").hide()
		if gridmap.get_cell_item(cell_coord.x, cell_coord.y, cell_coord.z - 1) >= 0:
			wall_block_inst.get_node("WallZN").disabled = true
			wall_block_inst.get_node("WallZN").hide()
	gridmap.hide()
