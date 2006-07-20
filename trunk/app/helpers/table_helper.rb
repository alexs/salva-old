module TableHelper
  def table_list(collection, options = {} )
    header = options[:header] 
    list = list_collection(collection, options[:columns])
    render(:partial => '/salva/list', 
           :locals => { :header => header, :list => list })
  end
  
  def list_collection(collection, columns)
    list = []
    collection.each { |row|
      text = columns_content(row, columns).join(', ').to_s+'.'
      list.push([text, row.id])
    }
    return list
  end
  
  def columns_content(row, columns)
    s = []
    if columns.is_a?Array then
      s = columns_totext(row, columns)
    else
      row.attributes().each { |key, value| 
        s << value if key != 'id' and value != nil 
      } 
    end
    return s
  end
  
  def columns_totext(row, columns)
    s = []
    columns.each { |attr| 
      next if row.send(attr) == nil 
      if is_id?(attr) then
        s << attributeid_totext(row, attr)
      else
        s << attribute_totext(row, attr)
      end
    } 
    return s
  end
  
  def attribute_totext(row, attr)
    return false unless row.send(attr) 
    if row.column_for_attribute(attr).type.to_s == 'boolean' then
      return get_boolean_tag(attr,row.send(attr))
    else
      return row.send(attr) 
    end
  end
  
  def attributeid_totext(row, attr)
    (model, field) = get_modelname(attr)
    if has_ancestors?(row,attr)
      return attribute_tree_path(row, field)
    elsif is_attribute_array?(row, attr)
      return ids_toname(model, get_ids_fromarray(row, attr))
    elsif has_associated_model?(row,attr,model) 
      return get_associated_attributes(row,attr,model,field)
    elsif row.send(model).has_attribute?(field)
      return row.send(model).send(field) 
    else 
      return columns_content(row.send(model), get_attributes(row,model)).join(', ')
    end
  end
  
  def has_ancestors?(row, attr)
    return true if attr.to_s == 'parent_id' and \
    row.public_methods.include? 'ancestors'
    return false
  end

  def attribute_tree_path(row, attr)
    s = []
    row.ancestors.reverse.each { | parent | s << parent.send(attr) }
    return s.join(',')
  end  
  
  def is_attribute_array?(row, attr)
    s = StringScanner.new(row.attributes_before_type_cast[attr])
    return true if s.match?(/^\{([0-9]+,*)+\}$/) != nil
    return false
  end
  
  def get_ids_fromarray(row, attr)
    return row.attributes_before_type_cast[attr].delete('{}').split(',')
  end
  
  def ids_toname(model, ids)
    s = []
    ids.each { |id| s << Inflector.camelize(model).constantize.find(id).name }
    s.join(',')
  end
  
  def has_associated_model?(row,attr,model)
    klass = row.class.name
    return true if klass.constantize.reflect_on_association(model.to_sym).options[:include]
    return false
  end

  def get_associated_attributes(row,attr,model,field)
    klass = row.class.name
    amodel = klass.constantize.reflect_on_association(model.to_sym).options[:include]
    if row.send(model).send(amodel).has_attribute?(field)
      return row.send(model).send(amodel).send(field) 
    end
  end
  
  def get_attributes(row,model)
    attributes = []
    row.send(model).attribute_names().each { |name|
      s = StringScanner.new(name)
      s.match?(/\w+_id/)
      attributes << name if s.matched?
    }
    return attributes
  end
  
  def is_id?(name)
    if name =~/_id$/ then
      true
    end
  end
  
  def get_modelname(attr)
    belongs_to = [ attr.sub(/_id$/,''), 'name' ]
    case attr
    when /citizen_/
      belongs_to[1] = 'citizen'
    end
    belongs_to
  end
  
  def get_boolean_tag(attr,condition)
    case attr
    when /gender/
      condition ? 'Masculino' : 'Femenino' 
    when /has_group_right/
      condition ? 'Con privilegios de grupo' : 'Sin privilegios'
    else
      condition ? 'S�' : 'No'
    end
  end  

  # ...
  def table_show(collection, options = {})
    default_hidden = %w(id dbtime moduser_id user_id created_on updated_on) 
    hidden = options[:hidden]    
    hidden = [ hidden ] unless hidden.is_a?Array
    hidden.each { |attr| default_hidden << attr } if hidden != nil
    
    body = []
    collection.each { |column| 
      attr = column.name
      if !default_hidden.include?(attr) then
        if is_id?(attr) then
          (model, field) = set_belongs_to(attr)
          body << [ attr, @edit.send(model).send(field) ] unless
            @edit.send(model) == nil 
        else
          next if @edit.send(attr) == nil
          if @edit.column_for_attribute(attr).type.to_s == 'boolean' then
            body << [ attr, setbool_tag(attr,@edit.send(attr))] 
          else
            body << [ attr, @edit.send(attr) ] 
          end
        end
      end
    }
    render(:partial => '/salva/show', :locals => { :body => body})
  end
end
