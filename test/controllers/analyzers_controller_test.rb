require 'test_helper'

class AnalyzersControllerTest < ActionController::TestCase
  setup do
    @analyzer = analyzers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:analyzers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create analyzer" do
    assert_difference('Analyzer.count') do
      post :create, analyzer: { directory: @analyzer.directory, lenguage: @analyzer.lenguage }
    end

    assert_redirected_to analyzer_path(assigns(:analyzer))
  end

  test "should show analyzer" do
    get :show, id: @analyzer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @analyzer
    assert_response :success
  end

  test "should update analyzer" do
    patch :update, id: @analyzer, analyzer: { directory: @analyzer.directory, lenguage: @analyzer.lenguage }
    assert_redirected_to analyzer_path(assigns(:analyzer))
  end

  test "should destroy analyzer" do
    assert_difference('Analyzer.count', -1) do
      delete :destroy, id: @analyzer
    end

    assert_redirected_to analyzers_path
  end
end
