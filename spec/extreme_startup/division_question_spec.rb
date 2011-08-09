require 'spec_helper'
require 'extreme_startup/question_factory'
require 'extreme_startup/player'

module ExtremeStartup
  describe DivisionQuestion do
    context "when the quotient is an integer" do
      let(:question) { DivisionQuestion.new(Player.new, 8, 2) }

      it "converts to the right string" do
        question.as_text.should =~ /what is 8 divided by 2/i
      end
      it "identifies a correct answer" do
        question.answer = "4"
        question.result.should == "correct"
      end
      it "identifies an wrong answer" do
        question.answer = "3"
        question.result.should == "wrong"
      end
      it "identified non-numeric as wrong" do
        question.answer = "four"
        question.result.should == "wrong"
      end
      it "identifies zero as wrong" do
        question.answer = "0"
        question.result.should == "wrong"
      end
    end
    
    context "when the quotient is an simple decimal" do
      let(:question) { DivisionQuestion.new(Player.new, 2, 8) }
      it "identifies a correct answer" do
        question.answer = "0.25"
        question.result.should == "correct"
      end
    end
    
    context "when the quotient is an infitite decimal" do
      let(:question) { DivisionQuestion.new(Player.new, 1, 3) }
      it "accepts answers with three correct decimal places" do
        question.answer = "0.333"
        question.result.should == "correct"
      end
      it "accepts answers with more correct decimal places" do
        question.answer = "0.333333333"
        question.result.should == "correct"
      end
    end
    
    
    context "when the divisor is zero" do
      let(:question) { DivisionQuestion.new(Player.new, 10, 0) }
      it "rejects empty answer" do
        question.answer = ""
        question.result.should == "wrong"
      end
      it "rejects zero" do
        question.answer = "0"
        question.result.should == "wrong"
      end
      it "rejects other numbers" do
        question.answer = "10"
        question.result.should == "wrong"
      end
    end
  end
end

