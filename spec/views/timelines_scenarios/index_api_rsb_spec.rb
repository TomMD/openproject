require File.expand_path('../../../spec_helper', __FILE__)

describe 'timelines/timelines_scenarios/index.api.rsb' do
  before do
    view.extend TimelinesHelper
  end

  before do
    params[:format] = 'xml'
  end

  describe 'with no scenarios available' do
    it 'renders an empty scenarios document' do
      assign(:scenarios, [])

      render

      response.should have_selector('scenarios', :count => 1)
      response.should have_selector('scenarios[type=array][size="0"]') do
        without_tag 'scenario'
      end
    end
  end

  describe 'with 3 scenarios available' do
    let(:scenarios) do
      [
        FactoryGirl.build(:timelines_scenario),
        FactoryGirl.build(:timelines_scenario),
        FactoryGirl.build(:timelines_scenario)
      ]
    end

    it 'renders a scenarios document with the size 3 of array' do
      assign(:scenarios, scenarios)

      render

      response.should have_selector('scenarios', :count => 1)
      response.should have_selector('scenarios[type=array][size="3"]')
    end

    it 'renders a scenario for each assigned scenario' do
      assign(:scenarios, scenarios)

      render

      response.should have_selector('scenarios scenario', :count => 3)
    end

    it 'renders the _scenario template for each assigned scenario' do
      assign(:scenarios, scenarios)

      view.should_receive(:render).exactly(3).times.with(hash_including(:partial => '/timelines/timelines_scenarios/scenario.api')).and_return('')

      # just to call the speced template despite the should receive expectations above
      view.should_receive(:render).once.with({ :template=>"timelines/timelines_scenarios/index", :handlers=>["rsb"], :formats=>["api"] }, {}).and_call_original

      render
    end

    it 'passes the scenarios as local var to the partial' do
      assign(:scenarios, scenarios)

      view.should_receive(:render).once.with(hash_including(:object => scenarios.first)).and_return('')
      view.should_receive(:render).once.with(hash_including(:object => scenarios.second)).and_return('')
      view.should_receive(:render).once.with(hash_including(:object => scenarios.third)).and_return('')

      # just to call the speced template despite the should receive expectations above
      view.should_receive(:render).once.with({ :template=>"timelines/timelines_scenarios/index", :handlers=>["rsb"], :formats=>["api"] }, {}).and_call_original

      render
    end
  end
end
