class PeopleidController < SalvaController
  def initialize
    super
    @model = Peopleid
    @create_msg = 'La identificaci�n ha sido agregada'
    @update_msg = 'La identificaci�n ha sido actualizada'
    @purge_msg = 'La identificaci�n se ha borrado'
    @per_pages = 10
    @order_by = 'personalidtype_id, descr'
  end
end