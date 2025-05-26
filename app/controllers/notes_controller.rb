class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  # GET /notes or /notes.json

  def index
    # Si un paramètre `my_notes` est passé dans l'URL, on filtre les notes par utilisateur
    if params[:my_notes]
      @notes = current_user.notes
    else
      @notes = Note.all  # Affiche toutes les notes
    end
  end
  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    @note = current_user.notes.build(note_params)

    respond_to do |format|
      if @note.save
        flash.now[:notice] = "Note was successfully created."
        format.turbo_stream
        format.html { redirect_to @note, notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @note.update(note_params)
      respond_to do |format|
        # nouveau truc qui permet d'envoyer une notif 'flash', franchement cool quand on veut faire quelque chose sans vouloir faire restart la page
        flash.now[:notice] = "Note was successfully updated."
        format.turbo_stream
        format.html { redirect_to notes_path, notice: "Note was successfully updated." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :edit, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end



  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy

    respond_to do |format|
      format.html { redirect_to notes_path, status: :see_other, notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :content)
    end
end
