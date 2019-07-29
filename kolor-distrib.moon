local sprite
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
    if color_occurences[color]
        color_occurences[color] += 1
    else
        color_occurences[color] = 1


create_color_table = (image) ->
    for x = 0, image.width - 1
        for y = 0, image.height - 1
            set_color_occurence image\getPixel(x, y)


-- Initialisation
init = () ->
    sprite = app.activeSprite
    
    return app.alert('There is no active sprite!') if not sprite

    path, filename, ext = split_filepath sprite.filename
    new_filepath = path .. filename .. "_kolor_distrib." .. ext

    sprite\saveCopyAs new_filepath

    sprite = Sprite { fromFile: new_filepath }
    sprite\flatten!

    cel = app.activeCel
    image = cel.image\clone!
    
    create_color_table image

    sprite\newLayer!

    -- TODO: Sort table by colour occurences
    -- table.sort color_occurences
    
    colors = [k for k, v in pairs color_occurences for i = 1, v]

    x = 0
    y = 0

    for i = 1, #colors
        image\drawPixel x, y, colors[i]

        x += 1

        if x >= sprite.width
            y += 1
            x = 0

    cel.image = image


init!
