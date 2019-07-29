local sprite, cel, image
color_occurences = {}


-- Splits a given full file path into its path, file (without extension) and the
-- extension (without the preceding .)
-- Params:
--      path - The path of a given file
-- Returns: a tuple containing the path, the filename (without extension) and
--          the extension
split_filepath = (path) ->
    string.match path, '(.-)([^\\]-)%.(.+)$'


-- Sets and updates the occurence counter for a given color
-- Params:
--      color - The Aseprite pixelcolor integer value that should be checked
set_color_occurence = (color) ->
    for i, v in ipairs color_occurences
        if v[1] == color
            color_occurences[i][2] += 1
            return
    
    table.insert(color_occurences, { color, 1 })


-- Creates a new table containing the colors and their occurence count of a
-- given image. The table is structured like this:
-- {
--      { 4283417946,  5 },
--      { 4283952127, 16 },
--      { 4282384639, 20 }
-- }
-- Note: Only the active layer will be used
-- Params:
--      image - The image from which you want to create a color table
create_color_table = (image) ->
    for x = 0, image.width - 1
        for y = 0, image.height - 1
            set_color_occurence image\getPixel(x, y)


-- Sorting function to sort two given color subtables
sort_by_occurence = (a, b) ->
    return a[2] > b[2]


-- Clone and flatten the sprite used for this script
create_new_sprite = () ->
    path, filename, ext = split_filepath sprite.filename
    new_filepath = path .. filename .. "_kolor_distrib." .. ext

    sprite\saveCopyAs new_filepath

    sprite = Sprite { fromFile: new_filepath }
    sprite\flatten!

    cel = app.activeCel
    image = cel.image\clone!


-- Draw the given colours along the pixelgrid of the sprite. Each color entry in
-- the given list will take exactly one pixel of space, i.e. if the color
-- #ff0000 exists three times in the list, three consecutive pixels will be
-- colored #ff0000
-- Params:
--      color_list - The list of color entries
draw = (color_list) ->
    x = 0
    y = 0

    for i = 1, #color_list
        image\drawPixel x, y, color_list[i]

        x += 1

        if x >= sprite.width
            y += 1
            x = 0

    cel.image = image


-- Initialisation
init = () ->
    sprite = app.activeSprite
    
    return app.alert('There is no active sprite!') if not sprite

    create_new_sprite!
    
    create_color_table image

    table.sort color_occurences, sort_by_occurence

    flattened_list = [color for i, color in ipairs color_occurences]

    colors = [color[1] for color in *flattened_list for i = 1, color[2]]

    draw colors


init!
