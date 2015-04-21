class Spinach::Features::AdminProjects < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths
  include SharedAdmin

  step 'I should see all projects' do
    Project.all.each do |p|
      page.should have_content p.name_with_namespace
    end
  end

  step 'I click on first project' do
    click_link Project.first.name_with_namespace
  end

  step 'I should see project details' do
    project = Project.first
    current_path.should == admin_namespace_project_path(project.namespace, project)
    page.should have_content(project.name_with_namespace)
    page.should have_content(project.creator.name)
  end

  step 'I visit admin project page' do
    visit admin_namespace_project_path(project.namespace, project)
  end

  step 'I transfer project to group \'Web\'' do
    find(:xpath, "//input[@id='new_namespace_id']").set group.id
    click_button 'Transfer'
  end

  step 'group \'Web\'' do
    create(:group, name: 'Web')
  end

  step 'I should see project transfered' do
    page.should have_content 'Web / ' + project.name
    page.should have_content 'Namespace: Web'
  end

  def project
    @project ||= Project.first
  end

  def group
    Group.find_by(name: 'Web')
  end
end