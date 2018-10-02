module RootInsurance
  module Api
    module Quote
      # Create a quote
      #
      # @param [Hash] opts The quote details. Depending on +:type+, different options are available. Available types are: +:root_gadgets+, +:root_term+ and +:root_funeral+ See below for details
      # @return [Hash]
      #
      ## == +:root_gadgets+
      # [model_name (String)]   The model name of the gadget
      #
      ## == +:root_term+
      # [cover_amount (Integer)]   Amount to cover, in cents. Should be between R100 000 and R5 000 000, inclusive.
      # [cover_period (String or Symbol)]   Duration to cover: +:1_year+, +:2_years+, +:5_years+, +:10_years+, +:15_years+, +:20_years+ or +:whole_life+.
      # [basic_income_per_month (Integer)]    Policyholder's basic monthly income, in cents.
      # [education_status (String or Symbol)]    Policyholder’s education class: +:grade_12_no_matric+, +:grade_12_matric+, +:diploma_or_btech+, +:undergraduate_degree+ or +:professional_degree+
      # [smoker (Boolean)]     Is the policyholder a smoker.
      # [gender (String or Symbol)]    Gender of policyholder. Should be either +:male+ or +:female+.
      # [age (Integer)]    Age of policyholder. Should be between 18 and 63, inclusive.
      #
      # == +:root_funeral+
      # [cover_amount (Integer)]   Amount to cover, in cents. Should be between R10k and R50k, inclusive.
      # [has_spouse (Boolean)]   Should a spouse also be covered.
      # [number_of_children (Integer)]   Number of children to include in the policy. Should be between 0 and 8, inclusive
      # [extended_family_ages (Array<Integer>)]   Ages of extended family members to cover.
      #
      # @example
      #  client.create_quote(
      #    type:       :root_gadgets,
      #    model_name: 'iPhone 6s 64GB LTE')
      #
      def create_quote(opts={})
        type = opts[:type]
  
        case type.to_sym
        when :root_gadgets
          create_gadget_quote(opts)
        when :root_term
          create_term_quote(opts)
        when :root_funeral
          create_funeral_quote(opts)
        else
          raise ArgumentError("Unknown quote type: #{type}")
        end
      end
  
      # List available gadget models
      #
      # @return [Array<Hash>]
      #
      # @example
      #   client.list_gadget_models
      #
      def list_gadget_models
        get('gadgets/models')
      end
  
      private
      def create_gadget_quote(opts)
        data = {
          type:       :root_gadgets,
          model_name: opts[:model_name]
        }
  
        post(:quotes, data)
      end
  
      def create_term_quote(opts)
        data = {
          type:             :root_term,
          cover_amount:     opts[:cover_amount],
          cover_period:     opts[:cover_period],
          education_status: opts[:education_status],
          smoker:           opts[:smoker],
          gender:           opts[:gender],
          age:              opts[:age],
          basic_income_per_month: opts[:basic_income_per_month],
        }
  
        post(:quotes, data)
      end
  
      def create_funeral_quote(opts)
        data = {
          type:                 :root_funeral,
          cover_amount:         opts[:cover_amount],
          has_spouse:           opts[:has_spouse],
          number_of_children:   opts[:number_of_children],
          extended_family_ages: opts[:extended_family_ages]
        }
  
        post(:quotes, data)
      end  
    end
  end
end
