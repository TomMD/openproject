require File.expand_path('../../../spec_helper', __FILE__)

describe 'timelines/timelines_projects/show.api.rsb' do
  before do
    view.extend TimelinesHelper
  end

  before do
    params[:format] = 'xml'
  end

  describe 'with an assigned project' do
    let(:project) { FactoryGirl.build(:project) }

    it 'renders a project document' do
      assign(:project,  project)

      render

      response.should have_selector('project', :count => 1)
    end

    it 'renders the _project view once' do
      assign(:project, project)

      view.should_receive(:render).once.with(hash_including(:partial => '/timelines/timelines_projects/project.api')).and_return('')

      # just to render the speced template despite the should receive expectations above
      view.should_receive(:render).once.with({:template=>"timelines/timelines_projects/show", :handlers=>["rsb"], :formats=>["api"]}, {}).and_call_original

      render
    end

    it 'passes the project as local var to the partial' do
      assign(:project, project)

      view.should_receive(:render).once.with(hash_including(:object => project)).and_return('')

      # just to render the speced template despite the should receive expectations above
      view.should_receive(:render).once.with({:template=>"timelines/timelines_projects/show", :handlers=>["rsb"], :formats=>["api"]}, {}).and_call_original

      render
    end
  end
end
