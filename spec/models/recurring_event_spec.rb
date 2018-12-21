require 'rails_helper'

RSpec.describe RecurringEvent, type: :model do
  let(:params){ {} }
  let(:recurring_event){ create(:recurring_event, params) }

  it 'triggers update_events on save' do
    expect(recurring_event).to receive(:update_events)
    recurring_event.save
  end

  describe 'update_events' do
    let(:params){ {frequency: frequency} }
    let(:first_event) { recurring_event.events.first }
    let(:second_event) { recurring_event.events.second }
    let(:date_diff){  (second_event.date - first_event.date).to_i }
    let(:frequency){ :daily }
    before do
      recurring_event.update_events
    end

    context 'frequency is daily' do
      it 'creates an event for every day' do
        expect(date_diff).to eq(1)
      end
    end
    context 'frequency is monthly' do
      let(:frequency){ :weekly }
      it 'creates an event for every day' do
        expect(date_diff).to eq(7)
      end
    end
    context 'frequency is quarterly' do
      let(:frequency){ :monthly }
      it 'creates an event for every day' do
        expect(date_diff).to be_between(28, 31)
      end
    end
    context 'frequency is quarterly' do
      let(:frequency){ :quarterly }
      it 'creates an event for every day' do
        expect(date_diff).to be_between(90, 93)
      end
    end

    context 'when an event property is changed' do
      let(:new_name){ 'New name' }
      let(:unique_name){ 'Unique name' }
      let!(:event_with_unique_name){
        recurring_event.events.second.tap{|event| event.update(name: unique_name) }
      }
      let!(:event_with_non_unique_name){ recurring_event.events.first }
      it 'only updates the events that have the matching old property' do
        recurring_event.name = new_name
        recurring_event.save!
        expect(event_with_non_unique_name.reload.name).to eq(new_name)
        expect(event_with_unique_name.reload.name).to eq(unique_name)
      end
    end
  end
end
