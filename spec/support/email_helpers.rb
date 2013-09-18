module EmailHelpers
  def it_should_send_emails(count, &block)
    it "should send #{count} emails" do
      expect { perform }.
      to change { ActionMailer::Base.deliveries.length }.
      by(count)
    end
  end
end

