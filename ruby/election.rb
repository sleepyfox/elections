class Election
  attr_reader :withDistrict

  def initialize(list, withDistrict = false)
    @list = list
    @withDistrict = withDistrict
    @candidates = []
    @officialCandidates = []
    @votesWithoutDistricts = []
    @votesWithDistricts = {
      "District 1" => [],
      "District 2" => [],
      "District 3" => []
    }
  end

  def addCandidate(candidate)
    @officialCandidates.push(candidate)
    @candidates.push(candidate)
    @votesWithoutDistricts.push(0)
    @votesWithDistricts["District 1"].push(0)
    @votesWithDistricts["District 2"].push(0)
    @votesWithDistricts["District 3"].push(0)
  end

  def voteFor(elector, candidate, electorDistrict)
    if !@withDistrict
      if @candidates.include?(candidate)
        index = @candidates.index(candidate)
        @votesWithoutDistricts[index] = @votesWithoutDistricts[index] + 1
      else
        @candidates.push(candidate)
        @votesWithoutDistricts.push(1)
      end
    else
      if @votesWithDistricts.has_key?(electorDistrict)
        districtVotes = @votesWithDistricts[electorDistrict]
        if @candidates.include?(candidate)
          index = @candidates.index(candidate)
          districtVotes[index] = districtVotes[index] + 1
        else
          @candidates.push(candidate)
          @votesWithDistricts.each do |district, votes|
            votes.push(0)
          end
          districtVotes[@candidates.count - 1] = districtVotes[@candidates.count - 1] + 1
        end
      end
    end
  end

  def results()
    results = {}
    nbVotes = 0
    nullVotes = 0
    blankVotes = 0
    nbValidVotes = 0

    if !@withDistrict
      nbVotes = votesWithoutDistricts.reduce(0, :+)
      i = 0
      while i < @officialCandidates.count() do
        index = @candidates.find_index { |c| c == @officialCandidates[i] }
        nbValidVotes += @votesWithoutDistricts[index]
        i += 1
      end
      
      i = 0
      while i < @votesWithoutDistricts.count() do
        candidatResult = (@votesWithoutDistricts[i] * 100) / nbValidVotes
        candidate = @candidates[i]
        if @officialCandidates.includes?(candidate)
          results[candidate] = "#{candidatResult.round(2)}%"
        else
          if @candidates[i].empty?
            blankVotes += votesWithoutDistricts[i]
          else
            nullVotes += votesWithoutDistricts[i]
          end
        end
        i += 1
      end
    else # withDistrict == true
      @votesWithDistricts.each do | entry | # entry is { k: [] }
        ArrayList<Integer> districtVotes = entry.getValue()
        nbVotes += districtVotes.stream().reduce(0, Integer::sum)
      end

#             for (int i = 0; i < officialCandidates.size(); i++) {
#                 int index = candidates.indexOf(officialCandidates.get(i))
#                 for (Map.Entry<String, ArrayList<Integer>> entry : votesWithDistricts.entrySet()) {
#                     ArrayList<Integer> districtVotes = entry.getValue()
#                     nbValidVotes += districtVotes.get(index)
#                 }
#             }

#             Map<String, Integer> officialCandidatesResult = new HashMap<>()
#             for (int i = 0; i < officialCandidates.size(); i++) {
#                 officialCandidatesResult.put(candidates.get(i), 0)
#             }
#             for (Map.Entry<String, ArrayList<Integer>> entry : votesWithDistricts.entrySet()) {
#                 ArrayList<Float> districtResult = new ArrayList<>()
#                 ArrayList<Integer> districtVotes = entry.getValue()
#                 for (int i = 0; i < districtVotes.size(); i++) {
#                     float candidateResult = 0
#                     if (nbValidVotes != 0)
#                         candidateResult = ((float)districtVotes.get(i) * 100) / nbValidVotes
#                     String candidate = candidates.get(i)
#                     if (officialCandidates.contains(candidate)) {
#                         districtResult.push(candidateResult)
#                     } else {
#                         if (candidates.get(i).isEmpty()) {
#                             blankVotes += districtVotes.get(i)
#                         } else {
#                             nullVotes += districtVotes.get(i)
#                         }
#                     }
#                 }
#                 int districtWinnerIndex = 0
#                 for (int i = 1; i < districtResult.size(); i++) {
#                     if (districtResult.get(districtWinnerIndex) < districtResult.get(i))
#                         districtWinnerIndex = i
#                 }
#                 officialCandidatesResult.put(candidates.get(districtWinnerIndex), officialCandidatesResult.get(candidates.get(districtWinnerIndex)) + 1)
#             }
#             for (int i = 0; i < officialCandidatesResult.size(); i++) {
#                 Float ratioCandidate = ((float) officialCandidatesResult.get(candidates.get(i))) / officialCandidatesResult.size() * 100
#                 results.put(candidates.get(i), String.format(Locale.FRENCH, "%.2f%%", ratioCandidate))
#             }
   end # if !@withDistrict

#         float blankResult = ((float)blankVotes * 100) / nbVotes
#         results.put("Blank", String.format(Locale.FRENCH, "%.2f%%", blankResult))

#         float nullResult = ((float)nullVotes * 100) / nbVotes
#         results.put("Null", String.format(Locale.FRENCH, "%.2f%%", nullResult))

#         int nbElectors = list.values().stream().map(List::size).reduce(0, Integer::sum)
#         DecimalFormat df = new DecimalFormat()
#         df.setMaximumFractionDigits(2)
#         float abstentionResult = 100 - ((float) nbVotes * 100 / nbElectors)
#         results.put("Abstention", String.format(Locale.FRENCH, "%.2f%%", abstentionResult))

    return results
  end # def results
end # class Election
