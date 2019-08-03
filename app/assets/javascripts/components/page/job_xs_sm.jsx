class JobXsSm extends React.Component{
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
            <div className={`row border_top ${highlight ? 'highlight' : ''} ${urgent ? 'urgent' : ''}`}>
                <div className='col-md-10'>
                    <h3>
                        <a href={url}>{title}</a>
                    </h3>
                    <span>
                       <a className='text-success' href={company_url}>{company}</a>
                       &nbsp; - &nbsp;
                    </span>
                    <span>
                        <a className='text-warning' href={location_url}>{location}</a>
                    </span>
                    {pSalary}
                    <p>{description+'...'}</p>
                    <p className="text-muted">
                        <span>Posted: {posted_date}</span>
                        <span className="pull-right">
                             <a  href= {apply} role= "button"  aria-disabled="true"  rel="nofollow">
                                Apply
                            </a>
                        </span>
                    </p>

                </div>
            </div>
        );
    }
}