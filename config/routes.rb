#encoding:utf-8
require 'httpclient'
Modengke::Application.routes.draw do



  ####万家物流
  resources :manco do
    #万家主页面
    get   'index'  ,:on=>:collection
    get  'main' ,:on=>:collection    ###万家介绍
    get  'history' ,:on=>:collection  ####万家历史
    #万家快递页面
     get 'find_manco',:on=>:collection
    get "black_index"  ,:on=>:collection   ##小黑版首页
    get "express"  ,:on=>:collection
    post "serach"  ,:on=>:collection
    get "blackbord",:on=>:collection
    post "blackbord_add" ,:on=>:collection
    get "follow",:on=>:collection    ###快递跟踪
    get 'user',:on=>:collection
  end

  get 'wlogin'=>"sessions#new_manco"
  get 'wregister'=>"sessions#register_manco"
  get 'wlogout'=>"sessions#destroy_manco"
  post 'users/manco' =>"users#manco_user" ,:controller=>"users"

  post 'wlogin'=>"sessions#create_manco"




  resources :tairyo do                   # #大渔饭店
    get   'index'  ,:on=>:collection
    get   'bus'  ,:on=>:collection
    get   'car'  ,:on=>:collection
    get   'walk'  ,:on=>:collection
    get   'group'  ,:on=>:collection
    get   'tuangouxiang'  ,:on=>:collection
    get   'tese'  ,:on=>:collection
    get   'user'  ,:on=>:collection
  end

  # 大渔用户注册登陆
  get 'tlogin'=>"sessions#new_tairyo"
  get 'tregister'=>"sessions#register_tairyo"
  get 'tlogout'=>"sessions#destroy_tairyo"
  post 'users/tairyo' =>"users#tairyo_user" ,:controller=>"users"
  post 'tlogin'=>"sessions#create_tairyo"
  #    #优惠卷
  get 'coupon'=>"coupon#index" ,:controller=>"coupons"
  get  'coupon/lingqu'=>"coupon#lingqu",:controller=>"coupons"

  #        #评论+优惠卷
  get 'comment_t'=>"comments#tairyo_comment",:controller=>"comments"
  post 'comment'=>"comments#tairyo",:controller=>"comments"

  get 'mycoupon'=>"coupon#mycoupon",  :controller=>"coupons"
  #    #特色




  mount WeixinRailsMiddleware::Engine, at: "/"

  resources :public_account

  root :to=>"home#index",:constraints=>{ :subdomain=>/^(www)?$/ }
  get 'blank'=>"home#blank"
  get 'home'=>"home#index"


  resources :pages, :only=>[:show]

  namespace :auth do
    resources :accounts
    resources :weixin do
      get 'callback',:on=>:collection
    end
    resources :weibo do
      get 'callback',:on=>:collection
    end
    resources :douban do
      get 'callback',:on=>:collection
    end
  end

  resources :sessions
  resources :users do
    get 'forgot_password', :on=>:collection
    #post 'send_reset_password_instruction', :on=>:collectiongem 'weixin_rails_middleware', git: "git://github.com/lanrion/weixin_rails_middleware.git", branch: "master"gem 'weixin_rails_middleware', git: "git://github.com/lanrion/weixin_rails_middleware.git", branch: "master"
    get 'reset_password',:on=>:collection
    post 'search', :on=>:collection
    post 'change_password',:on=>:collection
  end

  resources :vshop do
    collection do
      get 'login'
      get 'register'
      get 'article'
      get 'apply'
      post 'search'
      post 'change_password'
      get 'goods'
      get 'orders'
      get 'members'
      get 'weixin'
    end
    member do
      get :category
    end


  end

  get 'login'=>"sessions#new"
  get 'mlogin'=>"sessions#new_mobile"
  get 'mregister'=>"sessions#register_mobile"
  post 'login'=>"sessions#create"
  post 'mlogin'=>"sessions#create"
  get 'logout'=>"sessions#destroy"
  get 'topmenu'=>"home#topmenu"

  scope :module=> "events" do
    resources :user_survey, :controller=>"survey" do
      post "add_mobile", :on=>:collection
    end
  end

  namespace :events do
    resources :applicants
  end

  resources :events


  scope :module => "blog" do
    #constraints :subdomain => "blog" do
    root :to => "articles#index"
    resources :articles

    #end
  end

  scope :module => "magazine" do
    # match 'subscription_success' => "topics#index"
    resources :topics do
      resources :pages
    end
    match '/more_topics' => 'topics#more'
    match '/list_topics' => 'topics#list'
    match '/flash' => 'flashes#index'
  end

  scope :module => "memberships" do
    match '/vip' => 'vip#index'
    resource  :card do
      collection do
        get 'search'

        get 'activation'
        post 'confirm_activation'
        post 'validate_activation'
        post 'activate'
        get 'complete_activation'
        post 'input_mobile'
        post 'select'
        put 'update_mobile'
        put 'modify_mobile'
        get 'cancel_mobile'

        get 'purchase'
        scope "purchase" do
          post 'confirm_buyer'
          post 'confirm_user'
          get 'user'
        end

        get 'send_sms_code'

      end
    end
    resources  :member_cards
  end

  get 'admin'=>'admin/sessions#new'

  namespace :admin do
    # subdomain = nil
    # subdomain = "www" if Rails.env == "production"
    # constraints :subdomain => subdomain do
    get 'logout'=>'sessions#destroy'
    resources :wechat do
      get :menu,:on=>:collection
      get :menu_edit,:on=>:collection
      get :followers, :on=>:collection
      get :followers_import, :on=>:collection
      get :groups, :on=>:collection
      get :batch_sending, :on=>:collection
      get :weixin,:on=>:collection
    end
    resources :resources
    resources :permissions do

    end
    resources :suppliers
    resources :sessions
    resources :coupons
    resources :goods_cats do
      get :create_top,:on=>:collection
      get :toggle_future,:on=>:member
      get :toggle_agent,:on=>:member
      get :toggle_sell,:on=>:member
      post :save_top,:on=>:collection
    end
    resources :goods_types do
      put :updateType,:on=>:member
    end
    resources :goods_labels do
      put :updateLabel,:on=>:member
      get :createLabel,:on=>:collection
    end
    resources :brand_adms do
      get :delete
      put :update_brand,:on=>:member
    end

    resources :goods do
      get "tairyo_show",  :on=>:collection
      post "export", :on=>:collection
      post "import", :on=>:collection
      post "remove_spec_item",:on=>:member
      get "add_spec_item",:on=>:member
      get "spec",:on=>:member
      put "update_spec",:on=>:member
      get 'select_goods',:on=>:collection
      get 'collocation',:on=>:member
      get 'set_suits',:on=>:member
      get 'cancel_suits',:on=>:member
      post 'create_collocation',:on=>:collection
      get 'search', :on=>:collection
      get 'select_gifts',:on=>:collection
      put 'batch',:on=>:collection
      get 'select_all',:on=>:collection
      get :toggle_future,:on=>:member
      get :toggle_agent,:on=>:member
      get :toggle_sell,:on=>:member
    end
    resources :spec_items

    resources :images do
      post "mark", :on=>:collection
      post "rollback",:on=>:collection
      post "refresh",:on=>:collection
    end
    resources :articles do
      post 'set_position',:on=>:collection
    end
    resources :topics do
      post 'set_position',:on=>:collection
      post 'published_at',:on=>:member
    end
    resources :pages

    resources :members do
      post "export",:on=>:collection
      post "column_reload",:on=>:collection
      post "send_sms",:on=>:collection
      post "send_sms2",:on=>:collection
      get :info,:on=>:member
      put :updateInfo,:on=>:member
    end

    resources :cards do
      get 'buy',:on=>:member
      get 'use',:on=>:member
      get 'edit_user',:on=>:member
      get 'edit_pay',:on=>:member
      get 'logs', :on=>:member
      post 'import', :on=>:collection
      post "export",:on=>:collection
      get "tag",:on=>:collection
      put "untag",:on=>:member
      put "cancel_order",:on=>:member
    end

    resources :users do
      get 'search',:on=>:collection
      post 'newuser',:on=>:collection
      put 'send_sms_code',:on=>:member
      put 'buy_card',:on=>:member
      put 'use_card',:on=>:collection
      get 'select', :on=>:member
      put 'validate_mobile',:on=>:member
    end
    resources :member_cards

    resources :tag_exts

    resources :configs

    resources :labels

    resources :emails do
      get 'send_all',:on=>:collection
    end

    resources :categories

    resources :applicants

    resources :events do
      get 'applicants',:on=>:member
    end

    resources :homes

    resources :brand_pages do
      get 'toggle', :on=>:member
      put 'order', :on=>:member
      put 'reco', :on=>:member
    end

    resources :promotions

    resources :new_coupons do
      get 'download', :on=>:member
      get  'select_coupons', :on=>:collection
    end

    resources :user_coupons

    resources :orders do
      collection do
        get 'search'
        post :export
        put 'batch'
      end

      member do
        get 'detail'
        get 'pay'
        post 'dopay'
        get 'delivery'
        post 'dodelivery'
        get 'print_order'
        get 'print_preparer'
        get 'reship'
        post 'doreship'
        get 'refund'
        post 'dorefund'
        get :comment
        put :update_memo
      end
    end

    resources :static_pages
    resources :footers

    resources :metas

    resources :specifications

    resources :tags

    resources :offline_coupons do
      get 'downloads',:on=>:member
    end

    resources :virtual_goods do
      post 'import', :on=>:collection
    end

    resources :payment_logs

    # end
  end
  get 'm' =>"mobile#show", :as=>"mobile" ,:controller=>"mobile"
  get 'm/user' =>"mobile#user"

  scope :module => "store" do
    resources :orders,:only=>[:tairyo_order]
    get 'tairyo_order'=>"orders#tairyo_order"

    get 'search' => "search#index", :as=> :search
    get 'mproducts' =>"goods#mobile", :as=>"goods" ,:controller=>"goods"
     get 'mancoproduct' =>"goods#mancoproduct",  :as=>"goods" ,:controller=>"goods"
    get 'tproducts' =>"goods#tairyo_tuan", :as=>"goods" ,:controller=>"goods"
    post'manco/serach_goods_manco'=>"goods#serach_goods_manco",:controller=>"goods"
    post 'manco/find_manco_good_first'=>"goods#find_manco_good_first",:controller=>"goods"    #通过AJAX查询出来价钱
    post 'manco/find_manco_good_second'=>"goods#find_manco_good_second",:controller=>"goods"    #通过AJAX查询出来价钱
    resources :products, :as=>"goods", :controller=>"goods" do
      # get 'newin',:on=>:collection
      get 'newest',:on=>:collection
      put 'fav',:on=>:member
      put 'unfav',:on=>:member
      get 'price',:on=>:member
      get 'more',:on=>:collection
      get 'suits', :on=>:collection
      get 'more_suits', :on=>:collection

    end

    resources :suppliers

    resources :coupons, :controller=>"offline_coupons" do
      post 'download',:on=>:member
    end

    resources :vgoods, :controller=>"virtual_goods",:only=>[:index,:show]
    post 'cart/tairyo_add'=>"cart#tairyo_add",:as=>:add_to_cart   #团购商品添加购物车
    post 'cart/add'=>"cart#add",:as=>:add_to_cart
    post 'cart/manco_add'=>"cart#manco_add" ,:as=>:add_to_cart
    resources :cart do
      post 'add',:on=>:collection
      get 'mobile', :on=>:collection
      get 'tairyo_cart',:on=>:collection
      post 'tairyo', :on=>:collection      #大渔订餐 不是团购
      get 'jinbalang',:on=>:collection
      get 'manco_black_buy',:on=>:collection
    end
    resources :brands,:only=>[:index,:show]
    resources :users
    resources :vshop
    resources :country, :as=>"countries", :controller=>"countries"
    resources :gallery, :as=>"cats", :controller=>"cats"

    get 'vgroup'=>"cats#show_group",:as=>"cats",:controller=>"cats"  #金芭浪饭店团购
    get 'mgallery' =>"cats#show_mobile", :as=>"cats",:controller=>"cats"
    resources :goods,  :as=>"orders", :controller=>"orders" do
      member do
        get :goods
      end
    end
    get 'tairyo_share' =>"orders#tairyo_share"
    get 'share' =>"orders#share"
    get 'order/black_manco' =>"orders#black_manco"
    resources :orders, :except=>[:index] do
      member do
        get 'to_inventory'
        get 'out_inventory'
        post :pay
        get :detail
        get :goods

      end
      collection do
        get 'check_coupon'
        get  'new_mobile'
        get  'new_tairyo'
        get 'new_manco'
        post 'new_manco'
        get 'new_mobile_addr'
        get 'ordersnew_manco'
      end
    end

    resources :payments do

      collection do
        get 'callback'
        get 'debug'
      end

      member do
        get 'pay'
        match ':adapter/notify'=>"payments#notify", :as=>"notify"
        match ':adapter/callback'=>"payments#callback", :as=>"callback"
        if Rails.env == 'development'
          get 'test_notify'
          get 'test_callback'
        end
      end
    end
  end

  scope '(:agent)',:module => "store" do
    resources :products, :as=>"goods", :controller=>"goods" do
      get 'newin',:on=>:collection
      get 'newest',:on=>:collection
      put 'fav',:on=>:member
      put 'unfav',:on=>:member
      get 'price',:on=>:member
    end

    # post 'cart/add'=>"cart#add",:as=>:add_to_cart
    resources :cart do
      post 'add',:on=>:collection
    end

    resources :users

  end


  scope :module => "patch" do
    resource :profile do
      member do
        get 'password'
        put 'modify_password'
      end
    end
    resources :cards do
      member do
        get 'loss'
        get 'contact'
        get 'cancel_loss'
        # get 'send_sms_code'
        post 'confirm_lost'
        post 'confirm_cancel'
        get 'buyer_tel'
        get 'user_tel'
        post 'update_buyer_tel'
        post 'update_user_tel'
        get 'activation'
      end
    end
    resource :member do
      member do
        get 'orders'
        get 'coupons'
        get 'cards'
        get 'advance'
        get 'after_sale'
        get 'favorites'
        get 'goods'
        get 'inventorys'
        get 'inventorylog'
        post 'export_inventory'

      end
    end

    resources :member_addrs do

      get '_form_manco_second' ,:on=>:collection
      post 'addship' ,:on=>:collection
    end
    resources :aftersales do
      get 'instruction', :on=>:collection
    end

    resource :validation do
      get 'email'
      get 'mobile'
      post 'verify'
      post 'sent'
      get 'verify_email'
    end
  end

  resources :comments,:only=>[:create]

  mount Ckeditor::Engine => '/ckeditor'



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
