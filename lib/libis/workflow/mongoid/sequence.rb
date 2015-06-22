#require 'mongoid/fields/validators/macro'

module Libis
  module Workflow
    module Mongoid

      # Include this module to add automatic sequence feature (also works for _id field, so SQL-Like autoincrement primary key can easily be simulated)
      # usage:
      # class KlassName
      #   include Mongoid::Document
      #   include LIBIS::Mongoid::Sequence
      # ...
      #   field :number, :type=>Integer
      #   sequence :number
      # ...
      # Note: only tested on Mongoid 3.x and 4.x
      module Sequence
        extend ActiveSupport::Concern

        #noinspection ALL
        module ClassMethods

          def sequence(_field, prefix = nil)
            # REPLACE FIELD DEFAULT VALUE
            _field = _field.to_s
            options = fields[_field].options.merge(
                default: lambda {
                  self.class.set_from_sequence(_field, prefix)
                },
                pre_processed: false
            )
            (options.keys - ::Mongoid::Fields::Validators::Macro::OPTIONS).each { |key| options.delete key }
            field(_field, options)
          end

          def set_from_sequence(_field, prefix)
            # Increase the sequence value and also avoids conflicts
            catch(:value) do
              value = nil
              begin
                value = seq_upsert(counter_id(_field), {'$inc' => {'value' => 1}}).send('[]', 'value')
                value = "#{prefix.is_a?(Proc) ? instance_eval(prefix.call) : prefix}_#{value}" if prefix
              end until self.where(_field => value).count == 0
              throw :value, value
            end
          end

          def reset_sequence(_field, value = 0)
            seq_upsert(counter_id(_field), {'$set' => {'value' => value}})
          end

          protected

          def counter_id(_field)
            #"#{self.name.underscore}##{_field}"
            "#{collection_name.to_s}##{_field}"
          end

          def sequences
            # mongo_session["#{self.collection_name.to_s}__seq"]
            mongo_session["__sequences__"]
          end

          def seq_upsert(counter_id, change)
            sequences.where(_id: counter_id).modify(change, upsert: true, new: true)
          end

        end

      end

    end
  end
end