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


set_color_occurence = (color) ->
    for i, v in ipairs color_occurences
        if v[1] == color
            color_occurences[i][2] += 1
            return
    
    table.insert(color_occurences, { color, 1 })


create_color_table = (image) ->
    for x = 0, image.width - 1
        for y = 0, image.height - 1
            set_color_occurence image\getPixel(x, y)


sort_by_occurence = (a, b) ->
    return a[2] > b[2]


create_new_sprite = () ->
    path, filename, ext = split_filepath sprite.filename
    new_filepath = path .. filename .. "_kolor_distrib." .. ext

    sprite\saveCopyAs new_filepath

    sprite = Sprite { fromFile: new_filepath }
    sprite\flatten!

    cel = app.activeCel
    image = cel.image\clone!


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
