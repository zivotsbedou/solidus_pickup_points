# frozen_string_literal: true

require_relative "lib/solidus_pickup_points/version"

Gem::Specification.new do |spec|
  spec.name = "solidus_pickup_points"
  spec.version = SolidusPickupPoints::VERSION
  spec.authors = ["Život s Béďou, z.s."]
  spec.email = "ahoj@zivotsbedou.cz"

  spec.summary = "Carrier pickup points for Solidus shipments"
  spec.description = "Stores the pickup point a customer chose in a carrier's picker on the Solidus shipment, " \
                     "checks its code against the carrier and shows it in the admin. Carrier extensions such " \
                     "as solidus_packeta plug into it."
  spec.homepage = "https://github.com/zivotsbedou/solidus_pickup_points#readme"
  spec.license = "BSD-3-Clause"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/zivotsbedou/solidus_pickup_points"
  spec.metadata["changelog_uri"] = "https://github.com/zivotsbedou/solidus_pickup_points/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.required_ruby_version = ">= 3.2"

  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  spec.files = files.grep_v(%r{^(spec|bin)/|^\.})
  spec.require_paths = ["lib"]

  spec.add_dependency "deface", "~> 1.9"
  spec.add_dependency "solidus_core", [">= 4.8", "< 5"]
  spec.add_dependency "solidus_support", ">= 0.12.0"

  spec.add_development_dependency "solidus_dev_support", "~> 2.12"
end
