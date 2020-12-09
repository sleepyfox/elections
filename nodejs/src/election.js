class Election {
  constructor(list = {}, withDistrict = false) {
    this.list = list
    this.withDistrict = withDistrict
    this.candidates = []
    this.officialCandidates = []
    this.votesWithoutDistricts = []
    this.votesWithDistricts = {
      "District 1": [],
      "District 2": [],
      "District 3": []
    }
  }

  addCandidate(candidate) {
    this.officialCandidates.push(candidate)
    this.candidates.push(candidate)
    this.votesWithoutDistricts.push(0)
    this.votesWithDistricts["District 1"].push(0)
    this.votesWithDistricts["District 2"].push(0)
    this.votesWithDistricts["District 3"].push(0)
  }

  voteFor(elector, candidate, electorDistrict) {
    if (!this.withDistrict) {
      if (this.candidates.includes(candidate)) {
        let index = this.candidates.indexOf(candidate)
        this.votesWithoutDistricts[index] = this.votesWithoutDistricts[index] + 1
      } else {
        this.candidates.push(candidate)
        this.votesWithoutDistricts.push(1)
      }
    } else {
      if (this.votesWithDistricts.hasOwnProperty(electorDistrict)) {
        let districtVotes = this.votesWithDistricts[electorDistrict]
        if (this.candidates.includes(candidate)) {
          let index = this.candidates.indexOf(candidate)
          districtVotes[index] = districtVotes[index] + 1
        } else {
          this.candidates.push(candidate)
          for (let district in this.votesWithDistricts) {
            this.votesWithDistricts[district].push(0)
          }
          districtVotes[this.candidates.length - 1] = districtVotes[this.candidates.length - 1] + 1
        }
      }
    }
  }


  results() {
    var results = {},
        nbVotes = 0,
        nullVotes = 0,
        blankVotes = 0,
        nbValidVotes = 0

    if (!this.withDistrict) {
      nbVotes = this.votesWithoutDistricts.reduce((a, b) => a + b, 0)
      for (let i = 0; i < this.officialCandidates.length; i++) {
        let index = this.candidates.indexOf(this.officialCandidates[i])
        nbValidVotes += this.votesWithoutDistricts[index]
      }

      for (let i = 0; i < this.votesWithoutDistricts.length; i++) {
        let candidatResult = (this.votesWithoutDistricts[i] * 100) / nbValidVotes
        let candidate = this.candidates[i]
        if (this.officialCandidates.includes(candidate)) {
          results[candidate] = candidatResult.toFixed(2) + "%"
        } else {
          if (this.candidates[i].length == 0) {
            blankVotes += this.votesWithoutDistricts[i]
          } else {
            nullVotes += this.votesWithoutDistricts[i]
          }
        }
      }
    } else {
      for (let entry in this.votesWithDistricts) {
        let districtVotes = this.votesWithDistricts[entry]
        nbVotes += districtVotes.reduce((a, b) => a + b, 0)
      }
      for (let i = 0; i < this.officialCandidates.length; i++) {
        let index = this.candidates.indexOf(this.officialCandidates[i])
        for (let entry in this.votesWithDistricts) {
          let districtVotes = this.votesWithDistricts[entry]
          nbValidVotes += districtVotes[index]
        }
      }
      let officialCandidatesResult = {}
      for (let i = 0; i < this.officialCandidates.length; i++) {
        officialCandidatesResult[this.candidates[i]] = 0
      }
      for (let entry in this.votesWithDistricts) {
        let districtResult = []
        let districtVotes = this.votesWithDistricts[entry]
        for (let i = 0; i < districtVotes.length; i++) {
          let candidateResult = 0
          if (nbValidVotes != 0) {
            candidateResult = (districtVotes[i] * 100) / nbValidVotes
          }
          let candidate = this.candidates[i]
          if (this.officialCandidates.includes(candidate)) {
            districtResult.push(candidateResult)
          } else {
            if (this.candidates[i] == "") {
              blankVotes += districtVotes[i]
            } else {
              nullVotes += districtVotes[i]
            }
          }
        }
        let districtWinnerIndex = 0
        for (let i = 1; i < districtResult.length; i++) {
          if (districtResult[districtWinnerIndex] < districtResult[i])
            districtWinnerIndex = i
        }
        officialCandidatesResult[this.candidates[districtWinnerIndex]] = officialCandidatesResult[this.candidates[districtWinnerIndex]] + 1
      }
      for (let i = 0; i < Object.keys(officialCandidatesResult).length; i++) {
        let ratioCandidate = officialCandidatesResult[this.candidates[i]] / Object.keys(officialCandidatesResult).length * 100
        results[this.candidates[i]] = ratioCandidate.toFixed(2) + "%"
      }
    }
    let blankResult = (blankVotes * 100) / nbVotes
    results["Blank"] = blankResult.toFixed(2) + "%"

    let nullResult = (nullVotes * 100) / nbVotes
    results["Null"] = nullResult.toFixed(2) + "%"

    let nbElectors = Object.values(this.list).reduce((a, b) => a + b.length, 0)
    let abstentionResult = 100 - (nbVotes * 100) / nbElectors
    results["Abstention"] = abstentionResult.toFixed(2) + "%"

    return results
  }
}

module.exports = Election
