class ProblemSetsController < ApplicationController

  load_and_authorize_resource
  skip_authorization_check :only => [:add_problem, :remove_problem]

  def add_problem # currently unused function
    @problem_set = ProblemSet.find(params[:problem][:problem_set_ids])
    authorize! :update, @problem_set
    problem = Problem.find(params[:problem_id])
    authorize! :use, problem
    if @problem_set.problems.exists?(problem)
      redirect_to(problem, :alert => "This problem set already contains this problem")
      return
    end
    @problem_set.problems.push(problem)
    redirect_to(problem, :notice => "Problem added.")
  end

  def remove_problem
    authorize! :update, @problem_set
    problem = Problem.find(params[:problem_id])
    @problem_set.problems.delete(problem)
    redirect_to(@problem_set, :notice => "Problem removed.")
  end

  # GET /problem_sets
  # GET /problem_sets.xml
  def index
    @problem_sets = @problem_sets.distinct
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @problem_sets }
    end
  end

  # GET /problem_sets/1
  # GET /problem_sets/1.xml
  def show
    @groups = Group.all
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @problem_set }
    end
  end

  # GET /problem_sets/new
  # GET /problem_sets/new.xml
  def new
    @problem_set.owner_id = current_user.id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @problem_set }
    end
  end

  # GET /problem_sets/1/edit
  def edit
  end

  # POST /problem_sets
  # POST /problem_sets.xml
  def create
    @problem_set.owner_id = current_user.id
    @problem_set.accessible = [:owner_id] if can? :transfer, @problem_set
    @problem_set.attributes = params[:problem_set]

    respond_to do |format|
      if @problem_set.save
        format.html { redirect_to(@problem_set, :notice => 'Problem set was successfully created.') }
        format.xml  { render :xml => @problem_set, :status => :created, :location => @problem_set }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @problem_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /problem_sets/1
  # PUT /problem_sets/1.xml
  def update
    @problem_set.accessible = [:owner_id] if can? :transfer, @problem_set
    respond_to do |format|
      if @problem_set.update_attributes(params[:problem_set])
        format.html { redirect_to(@problem_set, :notice => 'Problem set was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @problem_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /problem_sets/1
  # DELETE /problem_sets/1.xml
  def destroy
    @problem_set.destroy

    respond_to do |format|
      format.html { redirect_to(problem_sets_url) }
      format.xml  { head :ok }
    end
  end
end
