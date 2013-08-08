require 'spec_helper'

describe 'Processing emails' do
  let(:username)    { 'booklog@arnebrasseur.net' }
  let(:config)      { MailReader::Config.new(username, 'pwd', 'server', '111', true) }
  let(:mail_reader) { MailReader.new(config) }
  let(:message)     { File.read(Rails.root.join('spec/fixtures/message01.eml')) }

  it 'should create new Book objects' do
    expect{ mail_reader.send_message(message) }.to change{ Book.count }.by(1)
  end
end
