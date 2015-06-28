require 'test_helper'

class PrimerosControllerTest < ActionController::TestCase
  setup do
    @primero = primeros(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:primeros)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create primero" do
    assert_difference('Primero.count') do
      post :create, primero: { cadena: @primero.cadena, resultado: @primero.resultado }
    end

    assert_redirected_to primero_path(assigns(:primero))
  end

  test "should show primero" do
    get :show, id: @primero
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @primero
    assert_response :success
  end

  test "should update primero" do
    patch :update, id: @primero, primero: { cadena: @primero.cadena, resultado: @primero.resultado }
    assert_redirected_to primero_path(assigns(:primero))
  end

  test "should destroy primero" do
    assert_difference('Primero.count', -1) do
      delete :destroy, id: @primero
    end

    assert_redirected_to primeros_path
  end
end
