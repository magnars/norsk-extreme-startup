require 'spec_helper'
require 'extreme_startup/question_factory'
require 'extreme_startup/player'

module ExtremeStartup
  describe GatedQuestionFactory do
    let(:player1)  { Player.new("player one") }
    let(:player2)  { Player.new("player two") }
    let(:firstQuestionSet) { [ WarmupQuestion ] }
    let(:secondQuestionSet) { [ AdditionQuestion, MaximumQuestion ] }
    let(:finalQuestionSet) { [ AdditionQuestion, MaximumQuestion, FibonacciQuestion ] }
    let(:factory)  { 
      GatedQuestionFactory.new([firstQuestionSet, secondQuestionSet, finalQuestionSet])
    }

   context "when player has not answered correctly" do
     it "should only give warmup question" do
       factory.available_questions(player1).should == firstQuestionSet
     end
   end

   context "when player has given a correct answer" do
     before { player1.answers_for_question(WarmupQuestion, "correct") }
     it "should give a new set of questions" do
      factory.available_questions(player1).should == secondQuestionSet
     end
     
     context "and player has answered a question from set 2" do
       before { player1.answers_for_question(AdditionQuestion, "correct") }
       it "should still use second question set" do
         factory.available_questions(player1).should == secondQuestionSet
       end
     end
     
     context "and player has answered all from set 2" do
       before do
        player1.answers_for_question(AdditionQuestion, "correct")
        player1.answers_for_question(MaximumQuestion, "correct")
       end
       it "should use third question set" do
         factory.available_questions(player1).should == finalQuestionSet
       end
       
       context "and player has answered the final question set" do
         before { player1.answers_for_question(FibonacciQuestion, "correct") }
         it "should continue to use the final question set" do
           factory.available_questions(player1).should == finalQuestionSet
         end
       end
     end
   end

   context "when other player has given correct answer" do
    before { player2.answers_for_question(WarmupQuestion, "correct") }
    it "should stille use the warmup question" do
      factory.available_questions(player1).should == firstQuestionSet
    end
   end
 end
end