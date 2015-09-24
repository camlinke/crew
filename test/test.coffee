assert = require 'assert'
express = require '..'
request = require 'supertest'
mongoose = require 'mongoose'
# chai = require('chai')
# chaiHttp = require 'chai-http'
# sw = require 'selenium-webdriver'
# driver = new sw.Builder()
#                .forBrowser('firefox')
#                .build()
# chaiWebdriver = require 'chai-webdriver'

# chai.use(chaiHttp)
# chai.use(chaiWebdriver(driver))

# Testing setup of mocha
describe 'Array', ->
    describe '#indexOf()', ->
        it 'should return -1 when the value is not present', () ->
            assert.equal(-1, [1,2,3].indexOf(5))
            assert.equal(-1, [1,2,3].indexOf(0))

describe 'Routing', ->
    url = "http://localhost:4000"

    describe 'Homepage', ->
        it "Should return 200 on homepage", () ->
            request url
                .get '/'
                .expect 200

# describe 'Groups', ->
#     url = "http://localhost:4000"

#     describe 'Create Group', ->
#         it "Should create a new group", () ->
#             request url
#                 .post('/groups/')



