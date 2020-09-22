require 'spec_helper'

describe 'MsdOdata::Entity' do
  describe '.expand' do
    before(:each) { @entity = MsdOdata::Entity.new('JournalHeaders') }

    it 'uses expand option with one property' do
      @entity.expand('company_restaurants')
      expect(@entity.query[:expand]).to eq('company_restaurants')
    end

    it 'uses expand option with multiple properties' do
      @entity.expand('company_restaurants', 'restaurant_branches')
      expect(@entity.query[:expand]).to eq('company_restaurants,restaurant_branches')
    end
  end

  describe '.order_by' do
    before(:each) { @entity = MsdOdata::Entity.new('UserGroupUserLists') }

    it 'uses order_by option with one property' do
      @entity.order_by('id')
      expect(@entity.query[:order_by]).to eq('id')
    end

    it 'uses order_by option with multiple properties' do
      @entity.order_by('id', 'name')
      expect(@entity.query[:order_by]).to eq('id,name')
    end
  end

  describe '.select' do
    before(:each) { @entity = MsdOdata::Entity.new('VendorInvoiceTotalTolerances') }

    it 'uses select option with one property' do
      @entity.select('id')
      expect(@entity.query[:select]).to eq('id')
    end

    it 'uses select option with multiple properties' do
      @entity.select('id', 'type', 'Customer_id')
      expect(@entity.query[:select]).to eq('id,type,Customer_id')
    end
  end

  describe '.skip' do
    before(:each) { @entity = MsdOdata::Entity.new('SalesOrderHeaders') }

    it 'uses skip option with a number' do
      @entity.skip(20)
      expect(@entity.query[:skip]).to eq(20)
    end

    it 'uses skip option with a string' do
      @entity.skip('id')
      expect(@entity.query[:skip]).to eq(0)
    end
  end

  describe '.limit' do
    before(:each) { @entity = MsdOdata::Entity.new('SalesOrderLines') }

    it 'uses limit option with one property' do
      @entity.limit(200)
      expect(@entity.query[:top]).to eq(200)
    end

    it 'uses limit option with multiple properties' do
      @entity.limit('id')
      expect(@entity.query[:top]).to eq(0)
    end
  end

  describe '.custom_param' do
    before(:each) { @entity = MsdOdata::Entity.new('LedgerJournalHeaders') }

    it 'uses custom param to add one param' do
      @entity.custom_param('cross-company=true')
      expect(@entity.query[:custom_param]).to eq('cross-company=true')
    end
  end

  describe '.where' do
    before(:each) { @entity = MsdOdata::Entity.new('ProductReceiptLines') }

    it 'uses where option with one property' do
      @entity.where(@entity[:id].ne(123))
      expect(@entity.query[:filters]).to eq('id ne 123')
    end

    it 'uses where option with multiple properties' do
      @entity.where(@entity[:id].ne(123), @entity[:name].eq('Khaled'))
      expect(@entity.query[:filters]).to eq("id ne 123 and name eq 'Khaled'")
    end

    it 'chains multiple where' do
      @entity.where(@entity[:id].ne(123)).where(@entity[:name].eq('Khaled'))
      expect(@entity.query[:filters]).to eq("id ne 123 and name eq 'Khaled'")
    end

    it 'uses where with not' do
      @entity.where(@entity[:id].ne(123)).not(@entity[:name].eq('Khaled'))
      expect(@entity.query[:filters]).to eq("(id ne 123) and not (name eq 'Khaled')")
    end
  end

  describe '.and' do
    before(:each) { @entity = MsdOdata::Entity.new('CallCenterCatalogCoupons') }

    it 'uses and option with one property' do
      @entity
        .where(@entity[:id].ne(123))
        .or(@entity[:name].eq(:Khaled))
        .and(@entity[:age].gt(20))
      expect(@entity.query[:filters]).to eq("id ne 123 or name eq 'Khaled' and age gt 20")
    end

    it 'uses and option with multiple properties' do
      @entity
        .where(@entity[:id].ne(123))
        .or(@entity[:name].eq(:Khaled), @entity[:age].gt(20))
      expect(@entity.query[:filters]).to eq("id ne 123 or name eq 'Khaled' and age gt 20")
    end
  end

  describe '.or' do
    before(:each) { @entity = MsdOdata::Entity.new('CourseTypes') }

    it 'uses or option with one property' do
      @entity
        .where(@entity[:id].ne(123))
        .or(@entity[:name].eq(:Khaled))
      expect(@entity.query[:filters]).to eq("id ne 123 or name eq 'Khaled'")
    end

    it 'uses or option with multiple properties' do
      @entity
        .where(@entity[:id].ne(123))
        .or(@entity[:name].eq(:Khaled), @entity[:age].gt(20))
      expect(@entity.query[:filters]).to eq("id ne 123 or name eq 'Khaled' and age gt 20")
    end
  end

  describe '.not' do
    before(:each) { @entity = MsdOdata::Entity.new('PositionDetails') }

    it 'uses not option with empty where' do
      @entity.where.not(@entity[:title].eq('Staff Manager'))
      expect(@entity.query[:filters]).to eq("not (title eq 'Staff Manager')")
    end

    it 'uses not option after where expression' do
      @entity
        .where(@entity[:grade].ge(12))
        .not(@entity[:title].eq('Staff Manager'))
      expect(@entity.query[:filters]).to eq("(grade ge 12) and not (title eq 'Staff Manager')")
    end
  end

  describe '.[]' do
    before(:each) { @entity = MsdOdata::Entity.new('ProductAllocations') }

    it 'uses [] with a string' do
      @entity['test']
      expect(@entity.instance_variable_get(:@attr)).to eq('test')
    end

    it 'uses [] with a symbol' do
      @entity[:test]
      expect(@entity.instance_variable_get(:@attr)).to eq('test')
    end
  end

  describe '.eq' do
    before(:each) { @entity = MsdOdata::Entity.new('RetailChannels') }

    it 'uses eq expression with a string value' do
      expression = @entity[:key].eq('val')
      expect(expression).to eq("key eq 'val'")
    end

    it 'uses eq expression with a symbol value' do
      expression = @entity[:key].eq(:val)
      expect(expression).to eq("key eq 'val'")
    end

    it 'uses eq expression with an integer value' do
      expression = @entity[:key].eq(100)
      expect(expression).to eq("key eq 100")
    end
  end

  describe '.ne' do
    before(:each) { @entity = MsdOdata::Entity.new('RetailChannels') }

    it 'uses ne expression with a string value' do
      expression = @entity[:key].ne('val')
      expect(expression).to eq("key ne 'val'")
    end

    it 'uses ne expression with a symbol value' do
      expression = @entity[:key].ne(:val)
      expect(expression).to eq("key ne 'val'")
    end

    it 'uses ne expression with an integer value' do
      expression = @entity[:key].ne(100)
      expect(expression).to eq("key ne 100")
    end
  end

  describe '.gt' do
    before(:each) { @entity = MsdOdata::Entity.new('RetailChannels') }

    it 'uses gt expression with a string value' do
      expression = @entity[:key].gt('val')
      expect(expression).to eq("key gt 'val'")
    end

    it 'uses gt expression with a symbol value' do
      expression = @entity[:key].gt(:val)
      expect(expression).to eq("key gt 'val'")
    end

    it 'uses gt expression with an integer value' do
      expression = @entity[:key].gt(100)
      expect(expression).to eq("key gt 100")
    end
  end

  describe '.ge' do
    before(:each) { @entity = MsdOdata::Entity.new('RetailChannels') }

    it 'uses ge expression with a string value' do
      expression = @entity[:key].ge('val')
      expect(expression).to eq("key ge 'val'")
    end

    it 'uses ge expression with a symbol value' do
      expression = @entity[:key].ge(:val)
      expect(expression).to eq("key ge 'val'")
    end

    it 'uses ge expression with an integer value' do
      expression = @entity[:key].ge(100)
      expect(expression).to eq("key ge 100")
    end
  end

  describe '.lt' do
    before(:each) { @entity = MsdOdata::Entity.new('RetailChannels') }

    it 'uses lt expression with a string value' do
      expression = @entity[:key].lt('val')
      expect(expression).to eq("key lt 'val'")
    end

    it 'uses lt expression with a symbol value' do
      expression = @entity[:key].lt(:val)
      expect(expression).to eq("key lt 'val'")
    end

    it 'uses lt expression with an integer value' do
      expression = @entity[:key].lt(100)
      expect(expression).to eq("key lt 100")
    end
  end

  describe '.le' do
    before(:each) { @entity = MsdOdata::Entity.new('RetailChannels') }

    it 'uses le expression with a string value' do
      expression = @entity[:key].le('val')
      expect(expression).to eq("key le 'val'")
    end

    it 'uses le expression with a symbol value' do
      expression = @entity[:key].le(:val)
      expect(expression).to eq("key le 'val'")
    end

    it 'uses le expression with an integer value' do
      expression = @entity[:key].le(100)
      expect(expression).to eq("key le 100")
    end
  end
end
