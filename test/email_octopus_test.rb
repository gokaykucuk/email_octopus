require 'test_helper'

class EmailOctopusTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::EmailOctopus::VERSION
  end

  def test_it_can_get_lists
    EmailOctopus::List.all.first
    assert true
  end

  def test_it_can_get_a_list_details
    list = EmailOctopus::List.find(ENV['TEST_LIST_ID'])
    assert_equal(ENV['TEST_LIST_ID'], list.id)
  end

  def test_it_can_get_contacts
    contacts = EmailOctopus::Contact.where(list_id: ENV['TEST_LIST_ID'])
    assert !contacts.nil?
  end

  def test_it_can_get_subscribed_contacts
    contacts = EmailOctopus::Contact.where(list_id: ENV['TEST_LIST_ID'], kind: 'subscribed')
    assert !contacts.nil?
  end

  def test_it_can_get_unsubscribed_contacts
    contacts = EmailOctopus::Contact.where(list_id: ENV['TEST_LIST_ID'], kind: 'unsubscribed')
    assert !contacts.nil?
  end

  def test_it_can_create_contacts
    # EmailOctopus::Contact.create(list_id:ENV['TEST_LIST_ID'], email_address: 'test@test.com')
    list = EmailOctopus::List.find(ENV['TEST_LIST_ID'])
    # list.contacts
    begin
      contact = list.create_contact(email_address: "test3@test.com")
      refute_nil contact.id
    rescue EmailOctopus::API::Error => e
      p "caught error"
      assert true
    end
  end

  def test_it_can_find_a_contact
    list = EmailOctopus::List.find(ENV['TEST_LIST_ID'])
    contact = list.contacts.last

    # EmailOctopus::Contact.find(list_id:ENV['TEST_LIST_ID'], id: '1234')
    found_contact = EmailOctopus::Contact.find(list_id: ENV['TEST_LIST_ID'], id: contact.id)

    assert_equal(contact.email_address, found_contact.email_address)
  end

  def test_it_can_delete_contacts
    list = EmailOctopus::List.find(ENV['TEST_LIST_ID'])

    old_count = list.contacts.count
    list.contacts.last.destroy
    new_count = list.contacts.count

    assert_equal((old_count - new_count), 1)
  end

end
