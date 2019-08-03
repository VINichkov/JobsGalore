class JobMd extends React.Component{
    constructor(props){
        super(props);
    }

    render() {
        const {urgent, highlight, title, location_url, location, salary, description, company_url,
                company_logo, company, posted_date, url, apply} = this.props.job;
        const image_style = {
            backgroundImage: `url(${company_logo})`,
            backgroundSize: 'contain',
            width: 130,
            height: 100
        };
        console.log(this.props.job);
        let pSalary;
        if (salary !== "") {
            pSalary = <p>{salary}</p>;
        }
        return (
            <div className="row">
                <div className='panel panel-default'>
                    <div className={`panel-body ${highlight ? 'highlight' : ''} ${urgent ? 'urgent' : ''}`}>
                        <div className='col-md-10'>
                            <h3>
                                <a className="text-warning" href={url}>{title}</a>
                            </h3>
                            {pSalary}
                            {description + "..."}
                            <p/>
                            <span>
                                <a className='text-success' href={company_url}>{company}</a>
                                &nbsp; - &nbsp;
                            </span>
                            <span>
                                <a className='text-warning' href={location_url}>{location}</a>
                            </span>
                            <span className="pull-right">
                                <a  href= {apply} role= "button"  aria-disabled="true"  rel="nofollow">
                                    Apply
                                </a>
                            </span>
                        </div>
                        <div className="col-md-2">
                            <div className="row">
                                <div className="text-center">
                                    <a href={company_url}>{company}</a>
                                </div>
                                <div className="text-center">
                                    <a href={company_url}>
                                        <div className="text-center img-thumbnail center-block avatar b-lazy b-error" style={image_style} />
                                    </a>
                                </div>
                            </div>
                            <div className="row text-center">
                                Posted:  {posted_date}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        );
    }
}