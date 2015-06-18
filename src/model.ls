module.exports =

  class MikroModel
    (num) ->
      @x = num

    property: 1

    method: (y) ->
      @x + @property + y
