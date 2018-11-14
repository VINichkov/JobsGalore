class ApplyJob extends React.Component{
    constructor(props){
        super(props);
        this.state={inputLetter:""};
        this._options={
                placeholder: {
                    text: 'Type your text here',
                    hideOnClick: true
                },
                toolbar: {
                    allowMultiParagraphSelection: true,
                    buttons: ['bold', 'italic', 'underline',  'h3' ,'h4' , 'orderedlist', 'unorderedlist'],
                    diffLeft: 0,
                    diffTop: -10,
                    firstButtonClass: 'medium-editor-button-first',
                    lastButtonClass: 'medium-editor-button-last',
                    relativeContainer: null,
                    standardizeSelectionStart: false,
                    static: false,
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
        if (this.props.resumes !== null && this.medium == null ) {
            let dom = ReactDOM.findDOMNode(this._divEditableL.current);
            this.setState({inputLetter:dom.innerHTML});
            this.medium = new MediumEditor(dom, this._options);
            this.medium.subscribe('editableInput', (e) => {
                this.setState({inputLetter:dom.innerHTML});
            });
        }
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
                          sign_up={this.props.sign_up}
                          linkedin_url = {this.props.linkedin_url}
            />;
        } else {
            let old_resume = this.props.resumes.map(function(resume, i){
                return (   <Resume resume = {this.state.resumes["resume_"+i].resume}
                                   onchange = {this.handleChangeFocus}
                                   name = "letter[resume]"
                                   check = {this.state.resumes["resume_"+i].checked}
                                   key ={i}
                                   keyResume = {i}/> );
            }.bind(this));
            step = <div>
                        <form action={this.props.send_url} method='post'>
                            <input type="text" name="letter[job]" className="none" defaultValue={this.props.job} value={this.props.job}/>
                            <NewResume location = {this.props.location}
                                       check = {this.state.resumes.new_resume.checked}
                                       categories = {this.props.categories}
                                       onchange = {this.handleChangeFocus}
                                       url_for_parse = {this.props.url_for_parse}
                                       user_from_linkedin = {this.props.user_from_linkedin}
                                       linkedin_resume_url ={this.props.linkedin_resume_url}
                                       options = {this._options}
                                       name="letter[new_resume]"
                                       nameCheckbox = "letter[resume]"/>
                            <hr/>
                            <p><strong>Resumes:</strong></p>
                            {old_resume}
                            <hr className="colorgraph"/>
                            <div className="form-group">
                                <label>A brief message to employer (optional)</label>
                                <br/>
                                <textarea name="letter[text]" value={this.state.inputLetter} className="markdown none" id="letter_description"></textarea>
                                <div id = 'letter' className="editable" ref={this._divEditableL}>
                                    <p>Hi,</p>
                                    <p>I'm interested in the {this.props.title.name} job which I found on <a href="www.jobsgalore.eu">Jobs Galore</a>. I believe I have the appropriate experience for this role. Please contact me if you would like to discuss further.</p>
                                    <p>I look forward to hearing from you.</p>
                                </div>
                            </div>
                            <div className="row">
                                <div className="col-xs-6 col-lg-6">
                                    <a href={this.props.title.link} className="btn btn-success btn-block">Back</a>
                                </div>
                                <div className="col-xs-6 col-lg-6">
                                    <input type="submit" className="btn btn-primary btn-block" value="Apply"/>
                                </div>
                            </div>
                            <br/>
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