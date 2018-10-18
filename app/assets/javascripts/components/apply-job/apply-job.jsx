class ApplyJob extends React.Component{
    constructor(props){
        super(props);
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
                return (   <Resume resume = {resume} key ={i}  keyResume = {i}/> );
            }.bind(this));
            step = <div>
                        <NewResume location = {this.props.location} categories = {this.props.categories}/>
                        <hr/>
                        <p><strong>Resumes:</strong></p>
                        {old_resume}
                    </div>
        }
        return(
            <div>
                {step}
            </div>
        );
    }
}