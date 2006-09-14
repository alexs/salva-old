class UserAdscriptionController < SalvaController
  def initialize
    super
    @model = UserAdscription
    @create_msg = 'La informaci�n se ha guardado'
    @update_msg = 'La informaci�n ha sido actualizada'
    @purge_msg = 'La informaci�n se ha borrado'
    @per_pages = 10
    @order_by = 'id'
  end

  def index
    @jobposition = Jobposition.find(:first, :conditions => [ 'user_id = ?', session[:user]])
    if @jobposition
      list
    else
      flash[:notice] = 'Por favor registre una categor�a antes de ingresar su adscripci�n...'
      redirect_to :controller => 'jobposition', :action => 'list'
    end
  end
end