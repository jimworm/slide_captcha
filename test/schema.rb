ActiveRecord::Schema.define(:version => 0) do
  create_table :slide_captcha_sessions, :force => true do |t|
  	t.integer	:slide_captcha_code_id
  	t.timestamps
  end
  
  create_table :slide_captcha_codes, :force => true do |t|
  	t.string	:code
  	t.timestamps
  end
end