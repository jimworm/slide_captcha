ActiveRecord::Schema.define(:version => 0) do
  create_table :slide_captcha_codes, :force => true do |t|
  	t.string	:code, :null => false
  end
  
  create_table :slide_captcha_sessions, :force => true do |t|
  	t.integer	:slide_captcha_code_id
  	t.timestamps
  end
  
  add_index :slide_captcha_codes, :code, :unique => true
end