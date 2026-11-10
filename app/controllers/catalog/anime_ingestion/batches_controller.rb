require "csv"

class Catalog::AnimeIngestion::BatchesController < ApplicationController
  before_action :set_catalog_anime_ingestion_batch, only: %i[ show destroy ]

  # GET /catalog/anime-ingestion/batches or /catalog/anime-ingestion/batches.json
  def index
    @catalog_anime_ingestion_batches = Catalog::AnimeIngestion::Batch.all
  end

  # GET /catalog/anime-ingestion/batches/1 or /catalog/anime-ingestion/batches/1.json
  def show
  end

  # GET /catalog/anime-ingestion/batches/new
  def new
    @catalog_anime_ingestion_batch = Catalog::AnimeIngestion::Batch.new
  end

  # POST /catalog/anime-ingestion/batches or /catalog/anime-ingestion/batches.json
  def create
    @catalog_anime_ingestion_batch = Catalog::AnimeIngestion::Batch.new(catalog_anime_ingestion_batch_params)

    respond_to do |format|
      if @catalog_anime_ingestion_batch.save
        format.html { redirect_to @catalog_anime_ingestion_batch, notice: "CSV uploaded and batch created" }
        format.json { render :show, status: :created, location: @catalog_anime_ingestion_batch }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @catalog_anime_ingestion_batch.errors, status: :unprocessable_content }
      end

      Catalog::AnimeIngestion::ProcessBatchJob.perform_later(@catalog_anime_ingestion_batch)
    end
  end

  def uploads
    @uploaded_file = params.dig(:catalog_anime_ingestion_batch, :csv_file)
    @file_name = @uploaded_file != nil ? @uploaded_file.original_filename : ""
    @headers = nil
    @rows = []

    if @uploaded_file.present?
      CSV.foreach(@uploaded_file.path, headers: true, liberal_parsing: true).first(10).each do |row|
        @headers ||= row.headers
        @rows << row
      end
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to new_catalog_anime_ingestion_batch_path }
    end
  end

  # DELETE /catalog/anime-ingestion/batches/1 or /catalog/anime-ingestion/batches/1.json
  def destroy
    @catalog_anime_ingestion_batch.destroy!

    respond_to do |format|
      format.html { redirect_to catalog_anime_ingestion_batches_path, notice: "Anime ingestion batch was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_anime_ingestion_batch
      @catalog_anime_ingestion_batch = Catalog::AnimeIngestion::Batch.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def catalog_anime_ingestion_batch_params
      params.expect(catalog_anime_ingestion_batch: [ :source, :csv_file ])
    end
end
