assert = require 'assert'
express = require '..'
request = require 'supertest'
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
            #     .end (err, res) ->
            #         expect res.text
            #             .dom.to.contain.text('mocha')
            # console.log(request(url))
            # expect(request(url).text).dom.to.contain.text('HOME')
            # chai.request url
            #     .get('/')
            #     .then (res) ->
            #         chai.expect(res).to.have.status(200)
                    # chai.expect(res).to.contain.text 'HOME'
                    # expect(res).dom.to.contain.text('HOME')
            # driver.get "#{url}/"
            #     .done()
                # .expect("h1").dom.to.contain.text("HOME")




