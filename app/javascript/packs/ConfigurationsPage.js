import React from 'react'
import ReactDOM from 'react-dom'
import { Page, Layout, SettingToggle } from '@shopify/polaris';

export default class ConfigurationsPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
    };
  }
  render() {
    return (
            <Page title="Configuration" >
            
              <Layout>
                 <Layout.AnnotatedSection
                    title="Seed and Update Products"
                 >
                  <SettingToggle
                    action={{content: 'Update', url: '#', onAction: () => this.seedProducts() }}
                  >
                    This will update the app with your latest products.
                  </SettingToggle>
                </Layout.AnnotatedSection>
                <Layout.AnnotatedSection
                    title="Google Analytics Refresh"
                 >
                  <SettingToggle
                    action={{content: 'Update', url: '#', onAction: () => this.queryGoogle() }}
                  >
                    This will send your app the latest Google Analytics Metrics manually. 
                    The app will automatically update this every 4 hours.
                  </SettingToggle>
                </Layout.AnnotatedSection>
                <Layout.AnnotatedSection
                    title="Update Price Tests"
                 >
                  <SettingToggle
                    action={{content: 'Update', url: '#', onAction: () => this.updatePriceTests() }}
                  >
                    This will update all your price tests manually. 
                    The app will automatically update this every 4 hours.
                  </SettingToggle>
                </Layout.AnnotatedSection>
              </Layout>
            </Page>
    );
  }

  seedProducts() {
    $.ajax( {
      url: '/seed_products_and_variants/',
      dataType: 'json',
      data: { id: this.props.shop_id },
      success: function() {
        console.log('success')
      }.bind(this),
      error: function(data) {
      }.bind(this)
    });
  }
  queryGoogle() {
    $.ajax( {
      url: '/query_google/',
      dataType: 'json',
      data: { id: this.props.shop_id },
      success: function() {
        console.log('success')
      }.bind(this),
      error: function(data) {
      }.bind(this)
    });
  }
  updatePriceTests() {
    $.ajax( {
      url: '/update_price_tests_statuses/',
      dataType: 'json',
      data: { id: this.props.shop_id },
      success: function() {
        console.log('success')
        //window.location = '/configurations'
      }.bind(this),
      error: function(data) {
      }.bind(this)
    });
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('configurations-page')
  const data = JSON.parse(node.getAttribute('data'))
ReactDOM.render(<ConfigurationsPage {...data}/>, node)
})
