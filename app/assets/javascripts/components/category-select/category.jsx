class Category extends React.Component{
    constructor(props){
        super(props);
        this.state = {options:null};
    }
    componentWillMount(){
        let data = this.props.categories;
        data.push({ id:999, name:"All"});
        let options = data.map(function (category) {
            if (this.props.defaultValue ? true : false) {
                if (this.props.defaultValue == category.id) {
                    return (<option key={category.id} selected value={category.id}>{category.name}</option>);
                } else {
                    return (<option key={category.id} value={category.id}>{category.name}</option>);
                }
            } else {
                if (999 == category.id) {
                    return (<option key={category.id} selected value={category.id}>{category.name}</option>);
                } else {
                    return (<option key={category.id} value={category.id}>{category.name}</option>);
                }
            }
        }.bind(this));
        this.setState({options:options});

    }
    render(){

        return(
            <select style={this.props.style} className={this.props.className} id = {this.props.id} name = {this.props.name}>
                {this.state.options}
            </select>
        );
    }
}