module MailingHelper

  def grid_contacts(elements, filter = nil)
     react_component(
        'Mailing',
        route: mailing_create_url,
        filterCompany: filter,
        elements: elements,
        minPriceForResume: Services::MAILING_RESUME_TO_COMPANY.min_price_int,
        minPriceForAd:Services::MAILING_ANY_AD_TO_COMPANY.min_price_int,
        oneEmailForResume:Services::MAILING_RESUME_TO_COMPANY.one_email_price_float,
        oneEmailForAd:Services::MAILING_ANY_AD_TO_COMPANY.one_email_price_float,
        type: {ad: Services::MAILING_ANY_AD_TO_COMPANY.name, resume: Services::MAILING_RESUME_TO_COMPANY.name},
        seeker: current_client&.applicant?,
        resumes: current_client&.applicant? ? current_client.resumes_for_apply : nil
    )
  end

  def show_letter(letters)
    react_component(
      'ShowLetters',
      letters: letters,
      newMessage: contacts_of_companies_url,
      url_for_synchronization: show_mailings_url
    )
  end

end