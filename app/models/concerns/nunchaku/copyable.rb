module Nunchaku
  module Copyable
    extend ActiveSupport::Concern
    include Nunchaku::Reflections

    module ClassMethods
      def copyable_attributes_blacklist
        %i(id created_at updated_at creator_id updator_id lock_version)
      end

      def copyable_overridden_attributes(source, parent)
        {}
      end

      def copyable_associations
        []
      end
    end

    def copy(deep=false)
      build_copy(self.class, self, self).tap { |c| copy_associations(c) if deep }
    end

    def copy!(deep=false)
      copy(deep).save!
    end

    def copy_associations(copy)
      self.class.copyable_associations.each do |a|
        send(a).find_each do |source|
          copy.send(a).push(build_copy(class_for(a), source, self))
        end
      end
    end

    def copied_attributes(klass)
      attributes.reject {|k, v| klass.copyable_attributes_blacklist.include?(k.to_sym) }
    end

    protected

    def build_copy(klass, source, parent)
      klass.new(source.copied_attributes(klass)).tap { |r| r.assign_attributes(klass.copyable_overridden_attributes(source, parent)) }
    end
  end
end
