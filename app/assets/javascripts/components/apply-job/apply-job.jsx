class ApplyJob extends React.Component{
    constructor(props){
        super(props);
        this._options={
                placeholder: {
                    /* This example includes the default options for placeholder,
                       if nothing is passed this is what it used */
                    text: 'Type your text here',
                    hideOnClick: true
                },
                toolbar: {
                    /* These are the default options for the toolbar,
                       if nothing is passed this is what is used */
                    allowMultiParagraphSelection: true,
                    buttons: ['bold', 'italic', 'underline', 'anchor', 'h3' ,'h4' , 'orderedlist', 'unorderedlist'],
                    diffLeft: 0,
                    diffTop: -10,
                    firstButtonClass: 'medium-editor-button-first',
                    lastButtonClass: 'medium-editor-button-last',
                    relativeContainer: null,
                    standardizeSelectionStart: false,
                    static: false,
                    /* options which only apply when static is true */
                    align: 'center',
                    sticky: false,
                    updateOnEmptySelection: false
                }
            };
        this._divEditableL = React.createRef();
        let resumes= {new_resume:{checked:false}};
        if (this.props.resumes !==null) {
            this.props.resumes.map(function (resume, i) {
                resumes["resume_" + i] = {resume: resume, checked: false};
            }.bind(this));
            resumes.resume_0 != null ? resumes.resume_0.checked = true : resumes.new_resume.checked = true;
            this.state = {
                resumes: resumes
            };
        }
        this.handleChangeFocus =  this.handleChangeFocus.bind(this);
    }
    componentDidMount(){
        let text = "<p>Hi,</p><p>I\'m interested in the Ruby engineer job which I found on Jora. I believe I have the appropriate experience for this role. Please contact me if you would like to discuss further.</p>"+
            "<p>I look forward to hearing from you.</p>";
        let dom = ReactDOM.findDOMNode(this._divEditableL.current);
        this.medium = new MediumEditor(dom, this._options);
        this.medium.subscribe('editableInput', (e) => {
            this._updated = true;
            this.change(dom.innerHTML);
        });

    }


    componentDidUpdate() {
        this.medium.restoreSelection();
    }

    componentWillUnmount() {
        this.medium.destroy();
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.text !== this.state.text && !this._updated) {
            this.setState({ text: nextProps.text });
        }
        if (this._updated) this._updated = false;
    }

    handleChangeFocus(e){
        let resumes = this.state.resumes;
        if (!resumes[e].checked){
            Object.keys(resumes).forEach(function (value) {
                resumes[value].checked = false;
            }.bind(this));
            resumes[e].checked = true;
            this.setState({resumes: resumes});
        }
    }

    render(){
        let step;
        if (this.props.resumes == null){
            step = <Autorization title = {this.props.title}
                          company = {this.props.company}
                          location = {this.props.location}
                          sign_in={this.props.sign_in}
                          linkedin_url = {this.props.linkedin_url}
            />;
        } else {
            let old_resume = this.props.resumes.map(function(resume, i){
                return (   <Resume resume = {this.state.resumes["resume_"+i].resume}
                                   onchange = {this.handleChangeFocus}
                                   check = {this.state.resumes["resume_"+i].checked}
                                   key ={i}
                                   keyResume = {i}/> );
            }.bind(this));
            step = <div>
                        <form>
                            <NewResume location = {this.props.location}
                                       check = {this.state.resumes.new_resume.checked}
                                       categories = {this.props.categories}
                                       onchange = {this.handleChangeFocus}
                                       url_for_parse = {this.props.url_for_parse}
                                       user_from_linkedin = {this.props.user_from_linkedin}
                                       linkedin_resume_url ={this.props.linkedin_resume_url}
                                       options = {this._options}/>
                            <hr/>
                            <p><strong>Resumes:</strong></p>
                            {old_resume}
                            <hr className="colorgraph"/>
                            <div className="form-group">
                                <label>A brief message to employer (optional)</label>
                                <br/>
                                <textarea name="letter[description]"  className="markdown none" id="letter_description"></textarea>
                                <div id = 'letter' className="editable" ref={this._divEditableL}>
                                    <p>Hi,</p>
                                    <p>I'm interested in the {this.props.title.name} job which I found on <a href="www.jobsgalore.eu">Jobs Galore</a>. I believe I have the appropriate experience for this role. Please contact me if you would like to discuss further.</p>
                                    <p>I look forward to hearing from you.</p>
                                </div>
                            </div>
                            <div className="row">
                                <div className="col-xs-6 col-lg-6">
                                    <input type="submit" className="btn btn-primary btn-block" />
                                </div>
                            </div>

                        </form>
                    </div>
        }
        return(
            <div>
                <h4> Are you applying for the following job:</h4>
                <h3><strong><a href={this.props.title.link}>{this.props.title.name}</a></strong></h3>
                <p>
                    <span className="text-success">
                        <span className="glyphicon glyphicon-home"></span>
                        &nbsp;
                        {this.props.company}
                    </span>
                    <span>&nbsp; - &nbsp;</span>
                    <span className="text-warning">
                        {this.props.location.name}
                    </span>
                </p>
                <hr className="colorgraph"/>
                {step}
            </div>
        );
    }
}