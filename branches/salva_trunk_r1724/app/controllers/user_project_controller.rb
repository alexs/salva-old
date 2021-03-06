class UserProjectController < SalvaController
  def initialize
    super
    @model = UserProject
    @create_msg = 'La información se ha guardado'
    @update_msg = 'La información ha sido actualizada'
    @purge_msg = 'La información se ha borrado'
    @per_pages = 10
    @list = { :conditions => 'roleinproject_id < 5' }
  end
end
