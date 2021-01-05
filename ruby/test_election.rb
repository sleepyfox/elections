require 'minitest/autorun'
require_relative './election.rb'

describe Election do
  describe "without district" do
    before do
      list = {
        "District 1" => ["Bob", "Anna", "Jess", "July"],
        "District 2" => ["Jerry", "Simon"],
        "District 3" => ["Johnny", "Matt", "Carole"]
      }
      @election = Election.new(list, false)
      @election.addCandidate("Michel");
      @election.addCandidate("Jerry");
      @election.addCandidate("Johnny")
      @election.voteFor("Bob", "Jerry", "District 1")
      @election.voteFor("Jerry", "Jerry", "District 2")
      @election.voteFor("Anna", "Johnny", "District 1")
      @election.voteFor("Johnny", "Johnny", "District 3")
      @election.voteFor("Matt", "Donald", "District 3")
      @election.voteFor("Jess", "Joe", "District 1")
      @election.voteFor("Simon", "", "District 2")
      @election.voteFor("Carole", "", "District 3")
    end

    it "must produce correct results" do
      results = @election.results()
      expectedResults = {
        "Jerry" => "50.00%",
        "Johnny" => "50.00%",
        "Michel" => "0.00%",
        "Blank" => "25.00%",
        "Null" => "25.00%",
        "Abstention" => "11.11%"
      }
      _(results).must_equal expectedResults
    end
  end
end

#     @Test
#     void electionWithDistricts() {
#         Map<String, List<String>> list = Map.of(
#                 "District 1" => Arrays.asList("Bob", "Anna", "Jess", "July"),
#                 "District 2" => Arrays.asList("Jerry", "Simon"),
#                 "District 3" => Arrays.asList("Johnny", "Matt", "Carole")
#         )
#         @Election @election = new Elections(list, true)
#         @election.addCandidate("Michel")
#         @election.addCandidate("Jerry")
#         @election.addCandidate("Johnny")

#         @election.voteFor("Bob", "Jerry", "District 1")
#         @election.voteFor("Jerry", "Jerry", "District 2")
#         @election.voteFor("Anna", "Johnny", "District 1")
#         @election.voteFor("Johnny", "Johnny", "District 3")
#         @election.voteFor("Matt", "Donald", "District 3")
#         @election.voteFor("Jess", "Joe", "District 1")
#         @election.voteFor("July", "Jerry", "District 1")
#         @election.voteFor("Simon", "", "District 2")
#         @election.voteFor("Carole", "", "District 3")

#         Map<String, String> results = @election.results()

#         Map<String, String> expectedResults = Map.of(
#                 "Jerry" => "66,67%",
#                 "Johnny" => "33,33%",
#                 "Michel" => "0,00%",
#                 "Blank" => "22,22%",
#                 "Null" => "22,22%",
#                 "Abstention" => "0,00%")
#         Assertions.assertThat(results).isEqualTo(expectedResults)
#     }
# }
