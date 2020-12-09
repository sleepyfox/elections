const Election = require('../src/election')
const assert = require('assert')

describe('Election Test', () => {
  it('Election without districts', () => {
    const list = { "District 1": ["Bob", "Anna", "Jess", "July"],
                   "District 2": ["Jerry", "Simon"],
                   "District 3": ["Johnny", "Matt", "Carole"]}
    var election = new Election(list, false)

    election.addCandidate("Michel")
    election.addCandidate("Jerry")
    election.addCandidate("Johnny")

    election.voteFor("Bob", "Jerry", "District 1")
    election.voteFor("Jerry", "Jerry", "District 2")
    election.voteFor("Anna", "Johnny", "District 1")
    election.voteFor("Johnny", "Johnny", "District 3")
    election.voteFor("Matt", "Donald", "District 3")
    election.voteFor("Jess", "Joe", "District 1")
    election.voteFor("Simon", "", "District 2")
    election.voteFor("Carole", "", "District 3")

    const results = election.results()

    const expectedResults = { "Jerry": "50.00%",
                              "Johnny": "50.00%",
                              "Michel": "0.00%",
                              "Blank": "25.00%",
                              "Null": "25.00%",
                              "Abstention": "11.11%" }
    assert.deepEqual(results, expectedResults)
  })

  it('Election with districts', () => {
    const list = { "District 1": ["Bob", "Anna", "Jess", "July"],
                   "District 2": ["Jerry", "Simon"],
                   "District 3": ["Johnny", "Matt", "Carole"]}

    var election = new Election(list, true)

    election.addCandidate("Michel")
    election.addCandidate("Jerry")
    election.addCandidate("Johnny")

    election.voteFor("Bob", "Jerry", "District 1")
    election.voteFor("Jerry", "Jerry", "District 2")
    election.voteFor("Anna", "Johnny", "District 1")
    election.voteFor("Johnny", "Johnny", "District 3")
    election.voteFor("Matt", "Donald", "District 3")
    election.voteFor("Jess", "Joe", "District 1")
    election.voteFor("July", "Jerry", "District 1")
    election.voteFor("Simon", "", "District 2")
    election.voteFor("Carole", "", "District 3")

    console.log(election)
    const results = election.results()
    const expectedResults = { "Jerry": "66.67%",
                              "Johnny": "33.33%",
                              "Michel": "0.00%",
                              "Blank": "22.22%",
                              "Null": "22.22%",
                              "Abstention": "0.00%" }
    assert.deepEqual(results, expectedResults)
  })
})
