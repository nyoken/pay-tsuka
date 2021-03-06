# frozen_string_literal: true

class ImageUploader < CarrierWave::Uploader::Base
  # リサイズと画像形式の変更用
  include CarrierWave::RMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # developmentとtestで画像保存ディレクトリを分ける
  def store_dir
    dir = "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    Rails.env.test? ? "uploads_#{Rails.env}/#{dir}" : "uploads/#{dir}"
  end

  def cache_dir
    dir = "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    Rails.env.test? ? "uploads_#{Rails.env}/tmp/#{dir}" : "uploads/tmp//#{dir}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # 過度な負荷を避けるために上限を設定
  process resize_to_limit: [700, 700]

  # サムネイル作成
  version :thumb do
    process resize_to_fit: [200, 300]
  end

  # 保存時に日付を付与
  def filename
    if original_filename.present?
      time = Time.now
      name = time.strftime('%Y%m%d%H%M%S') + '.jpg'
      name.downcase
    end

    # ファイル名を変更し拡張子をjpgに揃える
    super.chomp(File.extname(super)) + '.jpg'
  end
end
