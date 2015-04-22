class EnableBtreeAndPgtrgmExtensions < ActiveRecord::Migration
  def change
    enable_extension 'btree_gist'
    enable_extension 'pg_trgm'
  end
end
