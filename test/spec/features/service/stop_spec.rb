require 'spec_helper'

describe 'service stop' do
  before(:each) do
    run("kontena service create test-1 redis:3.0")
    run("kontena service create test-2 redis:3.0")
    run("kontena service deploy test-1")
  end

  after(:each) do
    run("kontena service rm --force test-1")
    run("kontena service rm --force test-2")
  end

  it 'stops running service' do
    k = kommando("kontena service stop test-1")
    expect(k.run).to be_truthy
    sleep 1
    k = run("kontena service show test-1")
    expect(k.out.scan('state: stopped').size).to eq(1)
    expect(k.out.scan('status: stopped').size).to eq(1)
  end

  it 'stops initialized service' do
    k = kommando("kontena service stop test-2")
    expect(k.run).to be_truthy
    sleep 1
    k = run("kontena service show test-2")
    expect(k.out.scan('state: stopped').size).to eq(1)
  end
end
