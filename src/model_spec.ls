require! {
  chai: {expect}
  './model': Model
}

describe 'MikroModel', (...) ->
  beforeEach ->
    @model = new Model

  it 'should work', ->
    expect(@model).to.be.an 'object'
