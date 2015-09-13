assert = require 'assert'
express = require '..'
request = require 'supertest'

# Testing setup of mocha
describe 'Array', () ->
    describe '#indexOf()', () ->
        it 'should return -1 when the value is not present', () ->
            assert.equal(-1, [1,2,3].indexOf(5))
            assert.equal(-1, [1,2,3].indexOf(0))

describe 'Routing', () ->
    url = "http://localhost:4000"

    describe 'Homepage', () ->
        it "Should have 'Hello World' on homepage", () ->
            request url
                .get '/'
                .expect 200
                .expect "Hello World!"