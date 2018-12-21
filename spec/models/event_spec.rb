require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:params){ {} }
  let(:event){ create(:event, params) }

  context 'when recurring_event_updates is passed' do
    let(:recurring_event_updates){ {
      start_date: '2018-12-18',
      end_date: '2019-12-18',
      frequency: 'weekly'
    }}
    context 'when there is an existing recurring event' do
      let(:recurring_event){ create(:recurring_event) }
      let!(:event){ create(:event, recurring_event: recurring_event) }
      it 'updates the existing recurring event' do
        expect(recurring_event).to receive(:update!).with(recurring_event_updates)
        event.update(recurring_event_updates: recurring_event_updates)
      end
    end
    context 'when there it no existing recurring event' do
      let!(:event){ create(:event) }
      it 'create a new recurring event' do
        expect(RecurringEvent).to receive(:create!) do |update_params|
          expect(update_params).to include(recurring_event_updates)
        end
        event.update(recurring_event_updates: recurring_event_updates)
      end
    end
  end
end
